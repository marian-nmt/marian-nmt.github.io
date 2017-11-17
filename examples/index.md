---
layout: docs
title: Examples & Use cases
permalink: /examples/
icon: fa-cogs
menu: 4
---

## Basic examples

- **{% github_link marian-examples/training-basics %}**: The scripts for
  training a [Edinburgh's WMT16
  system](http://www.aclweb.org/anthology/W16-2323) adapted from the
  Romanian-English sample from <https://github.com/rsennrich/wmt16-scripts>.
  The resulting system should be competitive or even slightly better than
  reported in that paper.
  need_, Vaswani et al., 2017](https://arxiv.org/abs/1706.03762).
- **{% github_link marian-examples/translating-amun %}**: The scripts
  demonstrate how to translate with Amun using Edinburgh's German-English
  WMT2016 single model and ensemble.
- **{% github_link marian-examples/transformer %}**: An example for training a
  Google-style transformer model introduced in [_Attention is all you

## Tutorials

### Machine Translation Marathon 2017 Tutorial

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

