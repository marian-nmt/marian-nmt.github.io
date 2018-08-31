---
layout: docs
title: MTM2018 Labs - Part 2
permalink: /examples/mtm2018/part2
icon: fa-cogs
---

## Translation with a pre-trained model

We will use the English-German model trained by the University of Edinburgh for
their submission to the WMT 2016 shared task on machine translation of news.
This is a shallow RNN-based encoder-decoder model with attention mechanism.

Models for all language pairs can be found
[here](http://data.statmt.org/wmt16_systems/).

### Downloading the data

First, download the model, vocabularies and data needed for preparing input texts:

```
wget -nv -nc -r -e robots=off -nH -np -R *ens* -R *r2l* -R index.html* \
    http://data.statmt.org/wmt16_systems/en-de/
```

We will translate the official WMT test sets from 2016 and evaluate translation
against human references using BLEU.  The files can be obtained from sacreBLEU:

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

### Translation

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

And translation:

```
cat data/newstest2015.ende.bpe.en \
  | ./marian-dev/build/marian-decoder -c config.ende.yml \
  > data/newstest2015.ende.bpe.out
```

Note: as in this example we use a model trained by the Nematus toolkit, model
architecture details (e.g. `--dim-emb` is used to specify length of embedding
vectors) needs to be provided as command-line options or in a config file.
Models trained with Marian already contain all information needed for the
decoder.

For multi-GPU translation, simply specify the device IDs:

```
./marian-dev/build/marian-decoder -c config.ende.yml --devices 0 1
```

And for CPU translation, specify number of threads that should be used:

```
./marian-dev/build/marian-decoder -c config.ende.yml --cpu-threads 4
```

### Data postprocessing and evaluation

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




## Training a basic NMT model

In this part of the tutorial we will use the data and scripts prepared for the
Romanian-English example from `marian-examples`.  First, clone the repository
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



```
./scripts/download-files.sh
./scripts/preprocess-data.sh
```

```
wget data.statmt.org/romang/marian-examples/training-basics.data.tgz
tar zxvf training-basics.data.tgz
ls data model 
```

### Training


```
  --model model/model.npz --type s2s \
  --train-sets data/corpus.bpe.ro data/corpus.bpe.en \
  --vocabs model/vocab.ro.yml model/vocab.en.yml \
```

```
  --devices 0 1 \
  --mini-batch-fit --workspace 3000 \
```

```
  --layer-normalization --exponential-smoothing \
```

```
  --dropout-rnn 0.2 --dropout-src 0.1 --dropout-trg 0.1 \
```

```
  --valid-metrics cross-entropy bleu \
  --valid-sets data/newsdev2016.bpe.ro data/newsdev2016.bpe.en \
  --valid-freq 10000 \
  --beam-size 12 --normalize \
  --early-stopping 5 \
```

```
  --disp-freq 1000 --quiet-translation \
  --log model/train.log --valid-log model/valid.log \
```

```
  --save-freq 10000 --overwrite --keep-best \
```

```
../../marian-dev/build/marian \
  --model model/model.npz --type s2s \
  --train-sets data/corpus.bpe.ro data/corpus.bpe.en \
  --vocabs model/vocab.ro.yml model/vocab.en.yml \
  --devices 0 1 \
  --mini-batch-fit --workspace 3000 \
  --layer-normalization --exponential-smoothing \
  --dropout-rnn 0.2 --dropout-src 0.1 --dropout-trg 0.1 \
  --valid-metrics cross-entropy bleu \
  --valid-sets data/newsdev2016.bpe.ro data/newsdev2016.bpe.en \
  --valid-freq 10000 \
  --beam-size 12 --normalize 1 \
  --early-stopping 5 \
  --disp-freq 1000 --quiet-translation \
  --log model/train.log --valid-log model/valid.log \
  --save-freq 10000 --overwrite --keep-best \
  --seed 1111
```

### Evaluation

```
cat data/newstest.bpe.ro \
  | ../../marian-dev/build/marian-decoder -c model/model.npz.best-translation.npz.decoder.yml \
    -d 0 1 -b 12 -n 1 \
  | sed 's/\@\@ //g' \
  | ../tools/moses-scripts/scripts/recaser/detruecase.perl \
  | ../tools/moses-scripts/scripts/tokenizer/detokenizer.perl -l en \
  > data/newstest2016.ro.out
```

```
cat data/newstest2016.ro.out | ./sacreBLEU/sacrebleu.py data/newstest2016.en
```

- - - -

Back to **[Part 1: Prerequisites](/examples/mtm2018/part1/)**

Continue with **[Part 3: Exercises](/examples/mtm2018/part3/)**
