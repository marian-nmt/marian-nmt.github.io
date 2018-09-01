---
layout: docs
title: MTM2018 Labs - Part 3
permalink: /examples/mtm2018/part3
icon: fa-cogs
---

## Exercises

Exercises are independent and can be performed in any order. Choose one you
like the most to start with.

### 1. Transformer

Train a transformer model following the example on {% github_link "training a
transformer-based English-German system" marian-examples/transformer %}.
Answer the questions:
- How is the training data preprocessed for source and target language?
- What is the architecture of the network?
- What regularization methods are applied?
- What is the mini-batch size?
- What learning-rate schedule is used?
- How many models are trained and how are they combined together?

### 2. Deep RNN model

Train a deep RNN-based encoder-decoder model following the example on {%
github_link "reconstructing Edinburgh's WMT17 English-German system"
marian-examples/wmt2017-uedin %}. Answer the same questions as in the first
exercise.

### 3. Language models

Based on the training exercise from Part 2 of this tutorial, train a language
model.  You may use preprocessed target side sentences as your training data.
During the training validate your model using perplexity on a development set.
Use `marian-scorer` to score new sentences with the created language model.

### 4. Custom embeddings

Train custom embedding vectors using [word2vec](http://github.com/dav/word2vec)
and use them to initialize embeddings in the NMT model from Part 2 of the
tutorial.  More information can be found in [the
documentaion](/docs/#custom-embeddings).

### 5. Multi-source models

Train a multi-source system for automatic post-editing.  Such a system takes a
pair of sentences as an input --- a sentence in source language and its
corresponding output from an unknown SMT system in target language --- and
generates an improved translation.  As training data, you may use [the
preprocessed data set of artificial
triplets](http://data.statmt.org/romang/ape-explore/train.tgz) created for our
submissions to WMT APE shared tasks in 2017 and 2018.

<!--### 6. N-best list rescoring-->
<!--### 7. Sentence weighting-->
<!--### 8. Word alignments from a transformer model-->

- - - -

Back to **[Part 1: Prerequisites](/examples/mtm2018/part1/)**

Back to **[Part 2: Basics](/examples/mtm2018/part2/)**
