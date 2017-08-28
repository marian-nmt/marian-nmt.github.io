---
layout: docs
title: MTM2017 Tutorial - Part 2
permalink: /examples/mtm2017/complex
icon: fa-cogs
---

# More complex models with Marian

## Deep models (Edinburgh WMT 2017 style)

In the upcoming WMT2017 paper from Edinburgh
*[Deep Architectures for Neural Machine Translation](https://arxiv.org/abs/1707.07631)*
the authors compare multiple known and novel deep architecturs. Marian implements
most of them as well as the tricks used to achieve faster convergence and smaller
models.

### Layer normalization

Layer normalization is a technique that greatly improves convergence of RNNs
(according to our own experiments by a factor 3-5) and also results in better
quality at test time. It is comparable to feature normalization where features
are normalized by subtracting their mean and dividing them by their variance. Instead
of only applying it to features, layer-normalization is applied to the activations
of the neural network. See [here](https://arxiv.org/abs/1607.06450) for more details.

Layer normalization is turned on by:
```
--layer-normalization
```

or in the config file with:

```
layer-normalization: true
```

### Tied embeddings

As the discussed models can become quite large, the tying of embedding matrices
can help to reduce models size and memory footprints during training.
As [Press&Wolf](https://arxiv.org/abs/1608.05859) show, tying target embeddings and
the last layer of the output does not decrease quality and helps saving significant
amounts of parameters. Activated by:

```
--tied-embeddings
```

or

```
tied-embeddings: true
```

### Deep decoders

The authors investigate two types of depth for the decoder.
Multi-layer RNNs and complex RNN cells that can again consist of cell-like
feed-forward layers. In the decoder the first RNN layer (the conditional cell that
contains the attention mechanism) and all other layers have separate depth settings.

We set the number of decoder layers with
```
--dec-depth 4
```
the number of feedword layers with the cell of the first and the following layers with
```
--dec-cell-base-depth 4
--dec-cell-high-depth 2
```

Alternatively, this can again be set in the config file:

```
dec-depth: 4
dec-cell-base-depth: 4
dec-cell-high-depth: 4
```

### Deep encoders

As for decoders, encoders can have multiple layers of complex RNN cells to be set
with:

We set the number of decoder layers with
```
--enc-depth 4
--dec-cell-depth 2
```
or

```
enc-depth: 4
enc-cell-depth: 2
```

Futhermore, the authors of the Edinburgh paper take a look at different encoder
types:

* **Bidirectional**: consists of a left-to-right and a right-to-left RNN that can
have mulitple layers of complex cells. The final output is concatenated. Activated by
`--enc-type bidirectional` or `enc-type: bidirectional`.
* **Bi-unidirectional**: Consists of a left-to-right and a right-to-left RNN with a
single layer of potentially complex cells. The outputs of the first layer are concatened
and then fed into more uni-directinal layers. Activated by
`--enc-type bi-unidirectional` or `enc-type: bi-unidirectional`.
* **Alternating**: Consists of two RNNs with alternating directionality per layer,
the final outputs are concatenated, used with `--enc-type alternating` or `enc-type: alternating`.

For `--enc-depth 1`, all three encoder types are reduced to the same single layer
bidirectional RNN.

### Residual connections

Residual connection allow to skip over layers by calculating `y = f(x) + x` where
`f` is the function represented by a layer. It is generally believed that residual
connections improve learning in deeper networks.

We activate residual connection between RNN layers on the command line with

```
--skip
```

or in the config file

```
skip: true
```

### Alternative RNN cells

During our own experiments, we found that LSTM cells work better for deeper
models (GRU cell seem to work better for the default shallow model).
The LSTM cell can be chosen separately for the encoder and decoder with the
following switches

```
--enc-cell lstm --dec-cell lstm
```

or with the yaml config file entries

```
enc-cell: lstm
dec-cell: lstm
```

### Putting it all together

This model will of course use a lot more memory on the GPU as the shallow models
 trained earlier. We increase the workspace memory to 6000 MB and create the config
 file as follows:

```
mkdir -p model.deep

./marian-dev/build/marian \
  --type s2s \
  --train-set data/corpus.clean.bpe.ro data/corpus.clean.bpe.en \
  --valid-set data/newsdev2016.bpe.ro data/newsdev2016.bpe.en \
  --vocabs data/vocab.ro.yml data/vocab.en.yml \
  --model model.deep/model.npz \
  --enc-depth 4 --enc-type alternating --enc-cell lstm --enc-cell-depth 2 \
  --dec-depth 4 --dec-cell lstm --dec-cell-base-depth 4 --dec-cell-high-depth 2 \
  --tied-embeddings --layer-normalization --skip \
  --dim-vocabs 66000 50000 \
  --dynamic-batching --workspace 6500 \
  --dropout-rnn 0.2 --dropout-src 0.1 --moving-average \
  --early-stopping 5 --disp-freq 1000 \
  --log model.deep/train.log --valid-log model.deep/valid.log \
  --dump-config > model.deep/config.yml
```

As before, we can just use the config file to start our training process:
```
./marian-dev/build/marian -c model.deep/config.yml
```

Translation is done in the same way as for the shallow models. The model file
constains information on its own architecture and the parameters can be ommitted
on the command line.

## Optional: dual-encoder models for automatic post-editing

Various models with multiple encoders and different attention mechanisms are
discussed in our paper *An Exploration of Neural Sequence-to-Sequence Architectures for Automatic Post-Editing*
available [here](https://arxiv.org/abs/1706.04138).

A first version (not quite done yet) of a companion page with config files for Marian and data to train multi-encoder
models is available [here](/examples/exploration/).

Back to **[Part 1: First steps with Marian](/examples/mtm2017/intro/)**

Continue with **[Part 3: A coding tutorial](/examples/mtm2017/code/)**
