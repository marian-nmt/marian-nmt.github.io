---
layout: docs
title: Custom models with Marian
permalink: /examples/tutorial/
icon: fa-cogs
---

## Checkout and Compilation

```
git clone https://github.com/marian-nmt/marian-train
cd marian-train
git checkout refactor-rnn
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j
```

## Skeleton model file

All file paths are relative to the main repository directory `marian-train`.
Create the file `src/models/sutskever.h` with the following skeleton code:

``` c++
#pragma once

#include "marian.h"

namespace marian {

class EncoderSutskever : public EncoderBase {
public:

  template <class... Args>
  EncoderSutskever(Ptr<Config> options, Args... args)
      : EncoderBase(options, args...) {}

  Ptr<EncoderState> build(Ptr<ExpressionGraph> graph,
                          Ptr<data::CorpusBatch> batch,
                          size_t encoderIndex) {
    using namespace keywords;

    return New<EncoderState>(nullptr, nullptr, batch);
  }
};

class DecoderSutskever : public DecoderBase {
public:
  template <class... Args>
  DecoderSutskever(Ptr<Config> options, Args... args)
      : DecoderBase(options, args...) {}

  virtual Ptr<DecoderState> startState(Ptr<EncoderState> encState) {
    using namespace keywords;

    rnn::States startStates;
    return New<DecoderState>(startStates, nullptr, encState);
  }

  virtual Ptr<DecoderState> step(Ptr<ExpressionGraph> graph,
                                 Ptr<DecoderState> state) {
    using namespace keywords;

    rnn::States decoderStates;
    return New<DecoderState>(decoderStates, nullptr, state->getEncoderState());
  }

};

typedef EncoderDecoder<EncoderSutskever, DecoderSutskever> Sutskever;

}
```

## Register the model

Each new model needs to be registered to be used later from the command line with
```
marian --type sutskever ...
```

Currently two files need to modified, this will later change to one location.

### For training

Edit `src/models/model_task.h` in the following way:

``` c++
#pragma once

// Add this include at the top
#include "models/sutskever.h"

[...]

template <template <class> class TaskName, template <class> class Wrapper>
Ptr<ModelTask> WrapModelType(Ptr<Config> options) {
  auto type = options->get<std::string>("type");

  // Add this line anywhere in the function
  REGISTER_MODEL("sutskever", Sutskever);

  UTIL_THROW2("Unknown model type: " << type);
}

[...]

}
```

### For translation

Edit the file `src/translator/scorers.h`

``` c++
#pragma once

#include "marian.h"

[...]

// Add this include at the top
#include "models/sutskever.h"

// find this function
Ptr<Scorer> scorerByType(std::string fname,
                         float weight,
                         std::string model,
                         Ptr<Config> options) {
  std::string type = options->get<std::string>("type");

  if(type == "s2s") {
    return New<ScorerWrapper<S2S>>(fname, weight, model, options);
  } else if(type == "amun") {
    return New<ScorerWrapper<Amun>>(fname, weight, model, options);
  } else if(type == "hard-att") {
    return New<ScorerWrapper<HardAtt>>(fname, weight, model, options);
  } else if(type == "hard-soft-att") {
    return New<ScorerWrapper<HardSoftAtt>>(fname, weight, model, options);
  }

  // Add this to register the scorer for the translator
  else if(type == "sutskever") {
    return New<ScorerWrapper<Sutskever>>(fname, weight, model, options);
  }

  else {
    UTIL_THROW2("Unknown decoder type: " + type);
  }

}

[...]

}

```
## Building a Sutskever-style model

### Encoder

#### Creating the embedding matrix
``` c++
// create source embeddings
int dimVoc = opt<std::vector<int>>("dim-vocabs")[encoderIndex];
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

  template <class... Args>
  EncoderSutskever(Ptr<Config> options, Args... args)
      : EncoderBase(options, args...) {}

  Ptr<EncoderState> build(Ptr<ExpressionGraph> graph,
                          Ptr<data::CorpusBatch> batch,
                          size_t encoderIndex) {
    using namespace keywords;

    // create source embeddings
    int dimVoc = opt<std::vector<int>>("dim-vocabs")[encoderIndex];
    auto embeddings = embedding(graph)
                      ("prefix", prefix_ + "_Wemb")
                      ("dimVocab", dimVoc)
                      ("dimEmb", opt<int>("dim-emb"))
                      .construct();

    // select embeddings that occur in the batch
    Expr batchEmbeddings, batchMask;
    std::tie(batchEmbeddings, batchMask)
      = EncoderBase::lookup(embeddings, batch, encoderIndex);

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
};
```

### Decoder

#### Setting the start state for decoding
``` c++
virtual Ptr<DecoderState> startState(Ptr<EncoderState> encState) {
  using namespace keywords;

  // Use first encoded word as start state
  auto start = marian::step(encState->getContext(), 0);

  rnn::States startStates({ {start, start} });
  return New<DecoderState>(startStates, nullptr, encState);
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
return New<DecoderState>(decoderStates, logits, state->getEncoderState());
```

#### The complete decoder

``` c++
class DecoderSutskever : public DecoderBase {
public:
  template <class... Args>
  DecoderSutskever(Ptr<Config> options, Args... args)
      : DecoderBase(options, args...) {}

  virtual Ptr<DecoderState> startState(Ptr<EncoderState> encState) {
    using namespace keywords;

    // Use first encoded word as start state
    auto start = marian::step(encState->getContext(), 0);

    rnn::States startStates({{start, start}});
    return New<DecoderState>(startStates, nullptr, encState);
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
    return New<DecoderState>(decoderStates, logits, state->getEncoderState());
  }

};
```

## Compile, train and translate

```
cd build
make -j
```

```
./build/marian --type sutskever -t corpus.bpe.ro corpus.bpe.en -v vocab.ro.yml vocab.en.yml -m model.npz
```

```
echo test | ./build/s2s --type sutskever -m model.npz -v vocab.ro.yml vocab.en.yml
```
