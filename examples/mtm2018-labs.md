---
layout: docs
title: MT Marathon 2018 Labs
permalink: /examples/mtm2018-labs
icon: fa-cogs
---

## Introduction

### Environmental setup

1. AWS EC2: follow the official MTM 2018 instructions on how to use your
   voucher and start an instance of an AWS virtual machine, then follow
   installation instructions below or use the [prepared docker files]().
2. Student machines at MTM: on machines equipped with GPUs (_u-pl21_ to
   _u-pl37_), you need to compile Marian with [a newer Boost
   version](/docs/#custom-boost) and disable CPU back-end by adding
   `-DCOMPILE_CPU=off` to CMake flags.
3. Private laptop or server: on machines with a UNIX system, CUDA and Boost
   installed, just follow installation instructions below. Add
   `-DCOMPILE_CUDA=off` on CPU-only machines with OpenBLAS or MKL installed.

### About Marian

**Marian** is an efficient Neural Machine Translation framework written in pure
C++ with minimal dependencies. It has mainly been developed at the Adam
Mickiewicz University in Poznań (AMU) and at the University of Edinburgh.
It is currently being deployed in multiple European and commercial projects.

Marian is also a Machine Translation Marathon 2016 project that is celebrating
its second birthday during the current MTM!

More information:
- [Features & benchmarks](/features)
- [Documentation](/docs)
- [FAQ](/faq)
- [Google discussion group](https://groups.google.com/forum/#!forum/marian-nmt)
- [GitHub issues](http://github.com/marian-nmt/marian-dev/issues)

## Installation

There are two repositories that marian can be obtained from:
`marian-nmt/marian` and `marian-nmt/marian-dev`.  The former includes the
latest stable release of Marian and Amun --- a fast C++ decoder for shallow
RNN-based encoder-decoder models and a predestor of Marian.  The latter is our
main development repository.

As Amun adds extra requirements, we suggest using `marian-dev` for this
tutorial.

### Requirements

Marian can be compiled on machines with NVIDIA GPU devices and CUDA 8.0+ or on
CPU-only machines.  The CPU version of Marian is compiled automatically if
OpenBLAS or Intel MKL (suggested) are found.  Compilation either of GPU or CPU
back-end can be disabled (details below).

Currently the main dependency of Marian is Boost, which should be already
installed on your machine.

### Checkout and compilation

To download the repository and compile Marian, run the following commands:

```
git clone https://github.com/marian-nmt/marian-dev
cd marian-dev
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j
```

If everything worked correctly you can display the list of options with:

```
./marian --help |& less
```

You should have at least these tools ready to use:

- `marian` - a tool for training NMT and LM models
- `marian-decoder` - a translation tool
- `marian-scorer` - a tool for scoring parallel texts and n-best lists

### Troubleshooting

- Compilation on a CPU-only machine: add flag `-DCOMPILE_CUDA=off` to the `cmake` command.
- Skipping compilation of CPU backend: add flag `-DCOMPILE_CPU=off` to the `cmake` command.
- Boost issues: see [instructions how to compile with custom Boost](/docs/#custom-boost).


### Tools

We will also need to download a couple of useful scripts for preprocessing,
splitting into subwords, and getting test files.

Return to the working directory and download the scripts:

```
cd ../..
git clone https://github.com/marian-nmt/moses-scripts
git clone https://github.com/rsennrich/subword-nmt
git clone https://github.com/mjpost/sacreBLEU -b master
```

## Translation

In the first part of the tutorial you will use Marian to translate with a
pre-trained model.  We will use the English-German model trained by the
University of Edinburgh for their submission to the WMT 2016 shared task on
machine translation of news.  This is a shallow RNN-based encoder-decoder model
with attention mechanism.

Models for all language pairs can be found
[here](http://data.statmt.org/wmt16_systems/).

### Downloading the data

First, download the model, vocabularies and data needed for preprocessing:

```
wget -nv -nc -r -e robots=off -nH -np -R *ens* -R *r2l* -R index.html* \
    http://data.statmt.org/wmt16_systems/en-de/
```

We will translate the official WMT test set from 2016 and evaluate its translation
against human references using BLEU.  The test files can be obtained from sacreBLEU:

```
mkdir data
./sacreBLEU/sacrebleu.py -t wmt15 -l en-de --echo src > data/newstest2015.ende.en
./sacreBLEU/sacrebleu.py -t wmt15 -l en-de --echo ref > data/newstest2015.ende.de
```

### Data preprocessing

We will first preprocess test files for translation. Make sure you understand
what each command is doing.

```
cat data/newstest2015.ende.en \
  | ./moses-scripts/scripts/tokenizer/normalize-punctuation.perl -l en \
  | ./moses-scripts/scripts/tokenizer/tokenizer.perl -l en -penn \
  | ./moses-scripts/scripts/recaser/truecase.perl -model wmt16_systems/en-de/truecase-model.en \
  > data/newstest2015.ende.bpe.en
```

### Translation command

We can now translate the given test set with the command below.  The files
`vocab.{ro,en}.yml` contain the input and output vocabulary, `model.npz` is the
model parameter file in Numpy format.  Run the command and check if you can
infer the model parameters (number of units in the rnn, number of layers,
etc.).

```
cat data/newstest2015.ende.bpe.en \
  | ./marian-dev/build/marian-decoder --models wmt16_systems/en-de/model.npz \
    --vocabs wmt16_systems/en-de/vocab.{en,de}.json --dim-vocabs 85000 85000 \
    --type amun --dim-emb 500 \
  > data/newstest2015.ende.bpe.out
```

Alternatively, instead of specifying command-line arguments, you can create a config file:

```
# File: config.ende.yml
type: amun
models:
  - wmt16_systems/en-de/model.npz
dim-emb: 500
vocabs:
  - wmt16_systems/en-de/vocab.en.json
  - wmt16_systems/en-de/vocab.de.json
dim-vocabs:
  - 85000
  - 85000
```

And provide it to the decoder:

```
cat data/newstest2015.ende.bpe.en \
  | ./marian-dev/build/marian-decoder -c config.ende.yml \
  > data/newstest2015.ende.bpe.out
```

Note: as in this example we use a model trained by the Nematus toolkit, model
architecture parameters (e.g. `--dim-emb`, which determines the size of embedding
vectors) need to be provided as command-line options or in a config file.
Models trained with Marian already contain all information needed.

For multi-GPU translation, just specify device IDs:

```
./marian-dev/build/marian-decoder -c config.ende.yml --devices 0 1
```

And for translation on CPU, set the number of threads:

```
./marian-dev/build/marian-decoder -c config.ende.yml --cpu-threads 4
```

### Evaluation

The output needs to be post-processed in order to compare it to the reference.
We fuse subwords back together, detokenize and uppercase the first letter in
each line:

```
cat data/newstest2015.ende.bpe.out \
  | ./moses-scripts/scripts/recaser/detruecase.perl \
  | ./moses-scripts/scripts/tokenizer/detokenizer.perl -l de \
  > data/newstest2015.ende.out
```

After that we can compute the BLEU score for this translation:

```
cat data/newstest2015.ende.out | ./sacreBLEU/sacrebleu.py data/newstest2015.ende.ref
```

### Exercise A

Using the description of command-line options and information from the
doumentation, modify the translation command above to achieve the following:
- Speed up the translation using batched translation.
- Try to get better translation quality by manipulating the beam size and
  length normalization factor.
- Output an n-best list with 5 best translation candidates.
- Generate word alignments and output attention matrices.


## Training

In this part of the tutorial we will use the data and scripts prepared for the
Romanian-English example from `marian-examples`.  First, download the repository
and helper scripts:

```
git clone https://github.com/marian-nmt/marian-examples
cd marian-examples/tools
make
cd ../training-basics
```

Instead of running the provided `./run-me.sh` and allowing everything to happen
magically, we will perform main steps one-by-one.

### Preparing training data

The training data for a Romanian-English NMT system can be downloaded and
preprocessed by executing the following scripts:

```
./scripts/download-files.sh
./scripts/preprocess-data.sh
```

Read carefully the second script.  Note, that the preprocessing of training
data for NMT usually consists of, but is not limited to, the following steps:
- Word tokenization
- Cleaning parallel sentences
- Truecasing
- Subword segmentation ([read here about BPEs](https://arxiv.org/abs/1508.07909))

Running these scripts may however take a while, therefore I recommend to skip
this during the labs and download the prepared data:

```
wget data.statmt.org/romang/marian-examples/training-basics.data.tgz
tar zxvf training-basics.data.tgz
```

### Training command

We can now train a model using our previously created training data. We use
`model` as our output folder and set the display freqency to 100, i.e. a status
update will be displayed every 100 mini-batch updates).

```
mkdir -p model

../../marian-dev/build/marian \
  --model model/model.npz \
  --train-set data/corpus.clean.bpe.ro data/corpus.clean.bpe.en \
  --disp-freq 100
```

Try to inspect the `--help` option to determine what kind of model will be
trained by default, e.g. what's the default batch size? or what kind of encoder
is used? is there regularization?

You can kill the training process with the key shortcut `Ctrl+C`.

Let's try a couple of more advanced options.  First, add `--mini-batch-fit`,
which overrides the specified mini-batch size and automatically choses the
largest mini-batch for a given sentence length that fits the specified
workspace memory.  The workspace memory needs to be below the size of your GPU
device as an extra memory is needed for the model itself.

```
  --mini-batch-fit --workspace 3000 \
```

We may add layer normalization, exponential smoothing, and dropouts as
regularization methods:

```
  --layer-normalization --exponential-smoothing \
  --dropout-rnn 0.2 --dropout-src 0.1 --dropout-trg 0.1 \
```

It is useful to monitor the performance of you model during training on
held-out data.  We provide validation sets for that using `--valid-sets` and
specify what metrics should be computed with `--valid-metrics`.  `--valid-freq`
sets the validation frequency.  What validation metrics do we use in this
example?  Is that BLEU score calculated on the validation set reliable? How we
can add data postprocessing here?

Attention: the validation set needs to have been preprocessed in exactly the
same manner as your training data.

Having the validation set specified we can also use the early stopping
technique to automatically determine when the training has converged and assume
it is finished.

```
  --valid-metrics cross-entropy bleu \
  --valid-sets data/newsdev2016.bpe.ro data/newsdev2016.bpe.en \
  --valid-freq 10000 \
  --beam-size 12 --normalize \
  --early-stopping 5 \
```

The model will be saved every 10,000 iterations and model checkpoints that
performs best according to each validation metrics will be kept.

```
  --save-freq 10000 --overwrite --keep-best \
```
Finally, we specify log files for the training and validation.

```
  --log model/train.log --valid-log model/valid.log \
```

Putting this all together gives as the command similar to the one below.

```
../../marian-dev/build/marian \
  --model model/model.npz --type s2s \
  --train-sets data/corpus.bpe.ro data/corpus.bpe.en \
  --vocabs model/vocab.ro.yml model/vocab.en.yml \
  --mini-batch-fit --workspace 3000 \
  --layer-normalization --exponential-smoothing \
  --dropout-rnn 0.2 --dropout-src 0.1 --dropout-trg 0.1 \
  --valid-metrics cross-entropy bleu \
  --valid-sets data/newsdev2016.bpe.ro data/newsdev2016.bpe.en \
  --valid-freq 10000 \
  --beam-size 12 --normalize 1 \
  --early-stopping 5 \
  --save-freq 10000 --overwrite --keep-best \
  --log model/train.log --valid-log model/valid.log \
  --devices 0 1 \
  --disp-freq 1000 --quiet-translation \
  --seed 1111
```

The training process will finish after quite a while, depending on the power of
your GPUs.  On four GeForce GTX 1080 cards this takes about 10 hours.


### Model evaluation

We can translate the preprocessed test file using the config file generated
during training:

```
cat data/newstest2016.bpe.ro \
  | ../../marian-dev/build/marian-decoder -c model/model.npz.best-translation.npz.decoder.yml \
    -d 0 1 -b 12 -n 1 \
  > data/newstest2016.bpe.out
```

Remember, that the evaluation should be performed on postprocessed output:

```
cat data/newstest2016.bpe.out \
  | sed 's/\@\@ //g' \
  | ../tools/moses-scripts/scripts/recaser/detruecase.perl \
  | ../tools/moses-scripts/scripts/tokenizer/detokenizer.perl -l en \
  > data/newstest2016.out
cat data/newstest2016.out | ./sacreBLEU/sacrebleu.py data/newstest2016.en
```

### Exercise B

Using the description of command-line options and information from the
doumentation, modify the training command above to achieve the following:
- Train a deep RNN model with 4 layers in the encoder and 4 layers in the decoder.
- Start training with the learning rate of 0.0002 and decrease it by 20% every
  epoch.
- Validate your model using BLEU on postprocessed data by adding custom
  validation script.


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

The preprocessed training data can be downloaded from
[data.statmt.org/romang/marian-examples](http://data.statmt.org/romang/marian-examples/transformer.data.tgz)

### 2. Deep RNN model

Train a deep RNN-based encoder-decoder model following the example on {%
github_link "reconstructing Edinburgh's WMT17 English-German system"
marian-examples/wmt2017-uedin %}. Answer the same questions as in the first
exercise.

The preprocessed training data can be downloaded from
[data.statmt.org/romang/marian-examples](http://data.statmt.org/romang/marian-examples/transformer.data.tgz)

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

