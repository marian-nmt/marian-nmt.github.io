---
layout: docs
title: Examples
permalink: /examples/
icon: fa-cogs
menu: 4
---

## Examples

- **{% github_link "Basic example for training" marian-examples/training-basics %}**:
  The scripts for training a [Edinburgh's WMT16
  system](http://www.aclweb.org/anthology/W16-2323) adapted from the
  Romanian-English sample from <https://github.com/rsennrich/wmt16-scripts>.
  The resulting system should be competitive or even slightly better than
  reported in that paper.

- **{% github_link "Training a transformer model" marian-examples/transformer %}**:
  An example for training a Google-style transformer model introduced in
  [_Attention is all you need_, Vaswani et al.,
  2017](https://arxiv.org/abs/1706.03762).

- **{% github_link "Training on raw texts with built-in SentencePiece" marian-examples/training-basics-sentencepiece %}**:
  The example shows how to use Taku Kudo's
  [SentencePiece](https://github.com/google/sentencepiece) and Matt Post's
  [SacreBLEU](https://github.com/mjpost/sacreBLEU) to greatly simplify the
  training and evaluation process by providing ways to have reversible hidden
  preprocessing and repeatable evaluation.

- **{% github_link "Reconstructing Edinburgh's WMT17 English-German system" marian-examples/wmt2017-uedin %}**:
  The scripts show how to train a complete WMT-grade system based on
  [Edinburgh's WMT submission
  description](http://www.aclweb.org/anthology/W17-4739) for en-de.

- **{% github_link "Reconstructing top WMT17 system with Marian's Transformer model" marian-examples/wmt2017-transformer %}**:
  The scripts show how to train a complete better than (!) WMT-grade system
  based on [Google's Transformer model](https://arxiv.org/abs/1706.03762) and
  [Edinburgh's WMT submission
  description](http://www.aclweb.org/anthology/W17-4739) for en-de.  This
  example is a combination of reproducing Edinburgh's WMT2017 system for en-de
  with Marian and the example for Transformer training.

- **{% github_link "Translating with Amun" marian-examples/translating-amun %}**:
  The scripts demonstrate how to translate with Amun using Edinburgh's
  German-English WMT2016 single model and ensemble.


## Tutorials

### MT Marathon 2019 Efficiency

**[The Machine Translation Marathon 2019 Tutorial](/examples/mtm2019)** shows
how to do efficient neural machine translation using the Marian toolkit by
optimizing the speed, accuracy and use of resources for training and decoding
of NMT models.


### MT Marathon 2018 Intro

**[The Machine Translation Marathon 2018 Labs](/examples/mtm2018-labs)** is a
Marian tutorial that covers topics like downloading and compiling Marian,
translating with a pretrained model, preparing training data and training a
basic NMT model, and contains list of exercises introducing different features
and model architectures available in Marian.

### MT Marathon 2017 Tutorial

- **[Part 1: First steps with Marian](/examples/mtm2017/intro/)**: Downloading
  and compiling Marian. Translation with a pretrained model.  Preparing a
  parallel corpus for training. Training a shallow encoder-decoder model with
  attention.
- **[Part 2: Complex models](/examples/mtm2017/complex/)**: Here we take a look
  at more complex models, for instance deeper models or multi-encoder models.
- **[Part 3: Coding tutorial](/examples/mtm2017/code/)**: Code a custom model,
  here a simple Sutskever-style model without attention.

## Use cases

- **[Winning system of the WMT 2016 APE shared task](/examples/postedit/)**:
  This page provides data and model files for our shared task winning APE
  system described in [Log-linear Combinations of Monolingual and Bilingual
  Neural Machine Translation Models for Automatic
  Post-Editing](http://www.aclweb.org/anthology/W16-2378).
- **[An Exploration of Neural Sequence-to-Sequence Architectures for Automatic
  Post-Editing](/examples/exploration/)**: This page provides data and model
  files and training instructions for our models described in [Junczys-Dowmunt
  & Grundkiewicz (2017). An Exploration of Neural Sequence-to-Sequence
  Architectures for Automatic Post-Editing](https://arxiv.org/abs/1706.04138).
