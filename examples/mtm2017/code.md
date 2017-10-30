---
layout: docs
title: MTM2017 Tutorial - Part 3
permalink: /examples/mtm2017/code/
icon: fa-cogs
---

# A Sutskever-style sequence-to-sequence model

**Note**: the tutorial has been updated for marian-dev version available in
commit a9279f1.

## Checkout and Compilation

If you skipped the previous parts, here's how to compile the code.

```
git clone https://github.com/marian-nmt/marian-dev
cd marian-dev
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j
```

## Skeleton model file

All file paths are relative to the main repository directory `marian-dev`.
Create the file `src/models/sutskever.h` with the following skeleton code:

``` c++
#pragma once

#include "marian.h"

namespace marian {

// Skeleton code for encoder
class EncoderSutskever : public EncoderBase {
public:
  EncoderSutskever(Ptr<Options> options) : EncoderBase(options) {}

  Ptr<EncoderState> build(Ptr<ExpressionGraph> graph,
                          Ptr<data::CorpusBatch> batch) {
    using namespace keywords;

    return New<EncoderState>(nullptr, nullptr, batch);
  }

  void clear() {}
};

// Skeleton code for decoder
class DecoderSutskever : public DecoderBase {
public:
  DecoderSutskever(Ptr<Options> options) : DecoderBase(options) {}

  virtual Ptr<DecoderState> startState(
      Ptr<ExpressionGraph> graph,
      Ptr<data::CorpusBatch> batch,
      std::vector<Ptr<EncoderState>>& encStates) {
    using namespace keywords;

    rnn::States startStates;
    return New<DecoderState>(startStates, nullptr, encStates);
  }

  virtual Ptr<DecoderState> step(Ptr<ExpressionGraph> graph,
                                 Ptr<DecoderState> state) {
    using namespace keywords;

    rnn::States decoderStates;
    return New<DecoderState>(decoderStates, nullptr, state->getEncoderStates());
  }

  void clear() {}
};

} // namespace marian
```

## Registering the model

In order to be able to use the model later during training or translation we
need to register it in model factory.

Edit `src/models/model_factory.h` in the following way: add the header include
at the top of the file:

``` c++
#pragma once

// Add this include at the top
#include "models/sutskever.h"
```

Register the encoder and the decoder:

``` c++
Ptr<EncoderBase> EncoderFactory::construct() {
  if(options_->get<std::string>("type") == "sutskever")
    return New<EncoderSutskever>(options_);

  [...]
}

Ptr<DecoderBase> DecoderFactory::construct() {
  if(options_->get<std::string>("type") == "sutskever")
    return New<DecoderSutskever>(options_);

  [...]
}
```

Specify how to construct the encoder-decoder Sutskever model:

``` c++
Ptr<ModelBase> by_type(std::string type, Ptr<Options> options) {
  if(type == "sutskever") {
    return models::encoder_decoder()(options)               //
        .push_back(models::encoder()("type", "sutskever"))  //
        .push_back(models::decoder()("type", "sutskever"))  //
        .construct();
  }

  [...]
}
```

## Filling the gaps

### Encoder

The complete encoder is given at the bottom of this section.
We insert the following code pieces in the `build` function of the encoder.

``` c++
// create source embeddings
int dimVoc = opt<std::vector<int>>("dim-vocabs")[batchIndex_];
auto embeddings = embedding(graph)
                  ("prefix", prefix_ + "_Wemb")
                  ("dimVocab", dimVoc)
                  ("dimEmb", opt<int>("dim-emb"))
                      .construct();
```

#### Embedding look-up

``` c++
// select embeddings that occur in the batch
Expr batchEmbeddings, batchMask;
std::tie(batchEmbeddings, batchMask)
    = EncoderBase::lookup(embeddings, batch, encoderIndex);
```

#### Backward encoder RNN

``` c++
// backward RNN for encoding
float dropoutRnn = inference_ ? 0 : opt<float>("dropout-rnn");
auto rnnBw = rnn::rnn(graph)
             ("type", "lstm")
             ("prefix", prefix_)
             ("direction", rnn::dir::backward)
             ("dimInput", opt<int>("dim-emb"))
             ("dimState", opt<int>("dim-rnn"))
             ("dropout", dropoutRnn)
             ("layer-normalization", opt<bool>("layer-normalization"))
                 .push_back(rnn::cell(graph))
                 .construct();

auto context = rnnBw->transduce(batchEmbeddings, batchMask);
```

#### The complete encoder

``` c++
class EncoderSutskever : public EncoderBase {
public:
  EncoderSutskever(Ptr<Options> options) : EncoderBase(options) {}

  Ptr<EncoderState> build(Ptr<ExpressionGraph> graph,
                          Ptr<data::CorpusBatch> batch) {
    using namespace keywords;

    // create source embeddings
    int dimVoc = opt<std::vector<int>>("dim-vocabs")[batchIndex_];
    auto embeddings = embedding(graph)
                      ("prefix", prefix_ + "_Wemb")
                      ("dimVocab", dimVoc)
                      ("dimEmb", opt<int>("dim-emb"))
                          .construct();

    // select embeddings that occur in the batch
    Expr batchEmbeddings, batchMask;
    std::tie(batchEmbeddings, batchMask)
        = EncoderBase::lookup(embeddings, batch);

    // backward RNN for encoding
    float dropoutRnn = inference_ ? 0 : opt<float>("dropout-rnn");
    auto rnnBw = rnn::rnn(graph)
                 ("type", "lstm")
                 ("prefix", prefix_)
                 ("direction", rnn::dir::backward)
                 ("dimInput", opt<int>("dim-emb"))
                 ("dimState", opt<int>("dim-rnn"))
                 ("dropout", dropoutRnn)
                 ("layer-normalization", opt<bool>("layer-normalization"))
                     .push_back(rnn::cell(graph))
                     .construct();

    auto context = rnnBw->transduce(batchEmbeddings, batchMask);

    return New<EncoderState>(context, batchMask, batch);
  }

  void clear() {}
};
```

### Decoder

Two methods have to be filled in the decoder: `startState` and `step`.

#### Setting the start state for decoding
``` c++
virtual Ptr<DecoderState> startState(
    Ptr<ExpressionGraph> graph,
    Ptr<data::CorpusBatch> batch,
    std::vector<Ptr<EncoderState>>& encStates) {
  using namespace keywords;

  // Use first encoded word as start state
  auto start = marian::step(encStates[0]->getContext(), 0, 2);

  rnn::States startStates({{start, start}});
  return New<DecoderState>(startStates, nullptr, encStates);
}
```

#### The step function

In the step function we define actions to be taken to either train on or create
the target sequence (all time steps during training, one time step during
translation).

##### Shifted embeddings

``` c++
auto embeddings = state->getTargetEmbeddings();
```

##### Decoder RNN

``` c++
// forward RNN for decoder
float dropoutRnn = inference_ ? 0 : opt<float>("dropout-rnn");
auto rnn = rnn::rnn(graph)
           ("type", "lstm")
           ("prefix", prefix_)
           ("dimInput", opt<int>("dim-emb"))
           ("dimState", opt<int>("dim-rnn"))
           ("dropout", dropoutRnn)
           ("layer-normalization", opt<bool>("layer-normalization"))
           .push_back(rnn::cell(graph))
           .construct();

// apply RNN to embeddings, initialized with encoder context mapped into
// decoder space
auto decoderContext = rnn->transduce(embeddings, state->getStates());

// retrieve the last state per layer. They are required during translation
// in order to continue decoding for the next word
rnn::States decoderStates = rnn->lastCellStates();
```

##### Deep output (2-layers)

``` c++
// construct deep output multi-layer network layer-wise
auto layer1 = mlp::dense(graph)
              ("prefix", prefix_ + "_ff_logit_l1")
              ("dim", opt<int>("dim-emb"))
              ("activation", mlp::act::tanh);
int dimTrgVoc = opt<std::vector<int>>("dim-vocabs").back();
auto layer2 = mlp::dense(graph)
              ("prefix", prefix_ + "_ff_logit_l2")
              ("dim", dimTrgVoc);

// assemble layers into MLP and apply to embeddings, decoder context and
// aligned source context
auto logits = mlp::mlp(graph)
              .push_back(layer1)
              .push_back(layer2)
              ->apply(embeddings, decoderContext);
```

##### Return the decoder state

``` c++
// return unormalized(!) probabilities
return New<DecoderState>(decoderStates, logits, state->getEncoderStates());
```

#### The complete decoder

``` c++
class DecoderSutskever : public DecoderBase {
public:
  DecoderSutskever(Ptr<Options> options) : DecoderBase(options) {}

  virtual Ptr<DecoderState> startState(
      Ptr<ExpressionGraph> graph,
      Ptr<data::CorpusBatch> batch,
      std::vector<Ptr<EncoderState>>& encStates) {
    using namespace keywords;

    // Use first encoded word as start state
    auto start = marian::step(encStates[0]->getContext(), 0, 2);

    rnn::States startStates({{start, start}});
    return New<DecoderState>(startStates, nullptr, encStates);
  }

  virtual Ptr<DecoderState> step(Ptr<ExpressionGraph> graph,
                                 Ptr<DecoderState> state) {
    using namespace keywords;

    auto embeddings = state->getTargetEmbeddings();

    // forward RNN for decoder
    float dropoutRnn = inference_ ? 0 : opt<float>("dropout-rnn");
    auto rnn = rnn::rnn(graph)
               ("type", "lstm")
               ("prefix", prefix_)
               ("dimInput", opt<int>("dim-emb"))
               ("dimState", opt<int>("dim-rnn"))
               ("dropout", dropoutRnn)
               ("layer-normalization", opt<bool>("layer-normalization"))
                   .push_back(rnn::cell(graph))
                   .construct();

    // apply RNN to embeddings, initialized with encoder context mapped into
    // decoder space
    auto decoderContext = rnn->transduce(embeddings, state->getStates());

    // retrieve the last state per layer. They are required during translation
    // in order to continue decoding for the next word
    rnn::States decoderStates = rnn->lastCellStates();

    // construct deep output multi-layer network layer-wise
    auto layer1 = mlp::dense(graph)
                  ("prefix", prefix_ + "_ff_logit_l1")
                  ("dim", opt<int>("dim-emb"))
                  ("activation", mlp::act::tanh);
    int dimTrgVoc = opt<std::vector<int>>("dim-vocabs").back();
    auto layer2 = mlp::dense(graph)
                  ("prefix", prefix_ + "_ff_logit_l2")
                  ("dim", dimTrgVoc);

    // assemble layers into MLP and apply to embeddings, decoder context and
    // aligned source context
    auto logits = mlp::mlp(graph)
                      .push_back(layer1)
                      .push_back(layer2)
                  ->apply(embeddings, decoderContext);

    // return unormalized(!) probabilities
    return New<DecoderState>(decoderStates, logits, state->getEncoderStates());
  }

  void clear() {}
};
```

## Compile, train and translate

```
cd build
make -j

cd ../..
```

Now you can train your Sutskever-style model with the following command. It is
possible to extend the model with multiple layers, see for instance the code in
`src/models/s2s.h`.

```
./marian-dev/build/marian \
  --type sutskever \
  -t data/corpus.clean.bpe.ro data/corpus.clean.bpe.en \
  -v data/vocab.ro.yml data/vocab.en.yml \
  -m model/model.npz
```

Translation will work as shown in Part 1 of the tutorial.

On an adjusted ro-en example from
`https://marian-nmt/marian/examples/training`, the Sutskever model should
achieve ca.~22 BLEU.

## For lazy people

If you just want to see how the final model looks like, you can chech out the
`tutorial-nov-17` branch:

```
cd marian-dev
cd build
git fetch origin tutorial-nov-17
git checkout tutorial-nov-17
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j
```

This will compile a version of Marian which already has the `sutskever` model
type.

Back to **[Part 2: Complex models](/examples/mtm2017/complex/)**
