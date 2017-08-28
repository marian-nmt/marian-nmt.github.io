---
layout: docs
title: MTM2017 Tutorial - Part 1
permalink: /examples/mtm2017/intro/
icon: fa-cogs
---

<b>Marian</b> is an efficient Neural Machine Translation framework written
  in pure C++ with minimal dependencies. It has mainly been developed at the
  Adam Mickiewicz University in Poznań (AMU) and at the University of Edinburgh.

  It is currently being deployed in multiple European projects and is the main
  translation and training engine behind the neural MT launch at the
  <a href="http://www.wipo.int/pressroom/en/articles/2016/article_0014.html">World Intellectual Property Organization</a>.

  <p>
  Main features:
  <ul>
    <li> Fast multi-gpu training and translation </li>
    <li> Compatible with Nematus and DL4MT </li>
    <li> Efficient pure C++ implementation </li>
    <li> Permissive open source license (MIT) </li>
    <li> <a href="{{ site.baseurl }}../../features"> more details... </a> </li>
  </ul>
  </p>

  It is also a Machine Translation Marathon 2016 project that is celebrating its
  first birthday during the current MTM :)

# First steps with Marian

Change your current working directory to mtm2017-marian

```
cd mtm2017-marian
```

## Checkout and Compilation

```
git clone https://github.com/marian-nmt/marian-dev
cd marian-dev
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j

```

If everything worked correctly you can display the list of options with
```
./marian --help
```

And download a couple of useful scripts:

Return to the working directory and download a number of scripts for
preprocessing and splitting into subwords:
```
cd ../..

git clone https://github.com/marian-nmt/mtm2017-tutorial
git clone https://github.com/marian-nmt/moses-scripts
git clone https://github.com/rsennrich/subword-nmt

```

## Tanslate with a pretrained model

We will first preprocess test files for translation. Make sure you understand
what each command is doing (normalise-romanian.py and remove-diacritics.py are
specialized commands for Romanian created by Barry Haddow).

```
cat mtm2017-tutorial/test/newstest2016.ro \
    | ./moses-scripts/scripts/tokenizer/normalize-punctuation.perl -l ro \
    | ./mtm2017-tutorial/scripts/normalise-romanian.py \
    | ./mtm2017-tutorial/scripts/remove-diacritics.py \
    | ./moses-scripts/scripts/tokenizer/tokenizer.perl -a -l ro \
    | ./moses-scripts/scripts/recaser/truecase.perl -model pretrained/truecase-model.ro \
    | ./subword-nmt/apply_bpe.py -c pretrained/roen.bpe > pretrained/newstest2016.tok.tc.bpe.ro

cat mtm2017-tutorial/test/newstest2016.en \
    | ./moses-scripts/scripts/tokenizer/normalize-punctuation.perl -l en \
    | ./moses-scripts/scripts/tokenizer/tokenizer.perl -a -l en > pretrained/newstest2016.tok.en

```

We can now translate the given test set with the command below. The
files `vocab.{ro,en}.yml` contain the input and output vocabulary, `model.npz`
is the model parameter file in Numpy format. Run the command and check
if you can infer the model parameters (number of units in the rnn, number of
layers, etc.).

```
cat pretrained/newstest2016.tok.tc.bpe.ro | \
  marian-dev/build/s2s -m pretrained/model.npz -v pretrained/vocab.ro.yml pretrained/vocab.en.yml \
  > pretrained/newstest2016.tok.tc.bpe.ro.output

```

The output `pretrained/newstest2016.tok.tc.bpe.ro.output` needs to be
post-processed in order to compare it to the tokenized reference.
We fuse subwords back together, detokenize and uppercase the first letter in each line:

```
cat pretrained/newstest2016.tok.tc.bpe.ro.output | \
  perl -pe 's/@@ //g' | \
  perl ./moses-scripts/scripts/recaser/detruecase.perl \
  > pretrained/newstest2016.tok.ro.output
```

After that we can compute the BLEU score for this translation:

```
perl ./moses-scripts/scripts/generic/multi-bleu.perl pretrained/newstest2016.tok.en < pretrained/newstest2016.tok.ro.output
```

## Training your own WMT-grade model

If you want to learn how to prepare your training data for a Romanian-English
NMT system, you should continue with the next section *Preprocessing your
data* and step through all the commands to create the training,
development and test data. This may however take a while, therefore I recommend
to skip it first and come back later.

If you skip this step, just rename the `data.done` folder to `data` and
move on to the following section *Training a basic Nematus-style model*.

### Preprocessing your data

Download the training data (this includes back-translated data by Rico Sennrich):
```
mkdir -p data
wget http://www.statmt.org/europarl/v7/ro-en.tgz -O data/ro-en.tgz
wget http://opus.lingfil.uu.se/download.php?f=SETIMES2/en-ro.txt.zip -O data/SETIMES2.ro-en.txt.zip
wget http://data.statmt.org/rsennrich/wmt16_backtranslations/ro-en/corpus.bt.ro-en.en.gz -O data/corpus.bt.ro-en.en.gz
wget http://data.statmt.org/rsennrich/wmt16_backtranslations/ro-en/corpus.bt.ro-en.ro.gz -O data/corpus.bt.ro-en.ro.gz

```

Unpack and concatenate the training data:
```
cd data/
tar -xf ro-en.tgz
unzip SETIMES2.ro-en.txt.zip
gzip -d corpus.bt.ro-en.en.gz corpus.bt.ro-en.ro.gz

cat europarl-v7.ro-en.en SETIMES2.en-ro.en corpus.bt.ro-en.en > corpus.en
cat europarl-v7.ro-en.ro SETIMES2.en-ro.ro corpus.bt.ro-en.ro > corpus.ro

cd ..

```

Tokenization and other language specific pre-processing steps:
```
cat data/corpus.ro \
    | ./moses-scripts/scripts/tokenizer/normalize-punctuation.perl -l ro \
    | ./mtm2017-tutorial/scripts/normalise-romanian.py \
    | ./mtm2017-tutorial/scripts/remove-diacritics.py \
    | ./moses-scripts/scripts/tokenizer/tokenizer.perl -threads 4 -a -l ro > data/corpus.tok.ro

cat data/corpus.en \
    | ./moses-scripts/scripts/tokenizer/normalize-punctuation.perl -l en \
    | ./moses-scripts/scripts/tokenizer/tokenizer.perl -threads 4 -a -l en > data/corpus.tok.en


cat mtm2017-tutorial/test/newsdev2016.ro \
    | ./moses-scripts/scripts/tokenizer/normalize-punctuation.perl -l ro \
    | ./mtm2017-tutorial/scripts/normalise-romanian.py \
    | ./mtm2017-tutorial/scripts/remove-diacritics.py \
    | ./moses-scripts/scripts/tokenizer/tokenizer.perl -threads 4 -a -l ro > data/newsdev2016.tok.ro

cat mtm2017-tutorial/test/newsdev2016.en \
    | ./moses-scripts/scripts/tokenizer/normalize-punctuation.perl -l en \
    | ./moses-scripts/scripts/tokenizer/tokenizer.perl -threads 4 -a -l en > data/newsdev2016.tok.en

cat mtm2017-tutorial/test/newstest2016.ro \
    | ./moses-scripts/scripts/tokenizer/normalize-punctuation.perl -l ro \
    | ./mtm2017-tutorial/scripts/normalise-romanian.py \
    | ./mtm2017-tutorial/scripts/remove-diacritics.py \
    | ./moses-scripts/scripts/tokenizer/tokenizer.perl -threads 4 -a -l ro > data/newstest2016.tok.ro

cat mtm2017-tutorial/test/newstest2016.en \
    | ./moses-scripts/scripts/tokenizer/normalize-punctuation.perl -l en \
    | ./moses-scripts/scripts/tokenizer/tokenizer.perl -threads 4 -a -l en > data/newstest2016.tok.en

```

Clean empty and long sentences, and sentences with high source-target ratio (training corpus only):
```
./moses-scripts/scripts/training/clean-corpus-n.perl data/corpus.tok ro en data/corpus.clean.tok 1 80
```

Train truecaser:
```
./moses-scripts/scripts/recaser/train-truecaser.perl -corpus data/corpus.clean.tok.ro -model data/truecase-model.ro
./moses-scripts/scripts/recaser/train-truecaser.perl -corpus data/corpus.clean.tok.en -model data/truecase-model.en
```

Apply truecaser to cleaned training corpus:
```
for prefix in corpus.clean newsdev2016 newstest2016
do
    ./moses-scripts/scripts/recaser/truecase.perl -model data/truecase-model.ro < data/$prefix.tok.ro > data/$prefix.tc.ro
    ./moses-scripts/scripts/recaser/truecase.perl -model data/truecase-model.en < data/$prefix.tok.en > data/$prefix.tc.en
done

```

Train BPE ([Read here about BPEs](https://arxiv.org/abs/1508.07909))
```
cat data/corpus.clean.tc.ro data/corpus.clean.tc.en | ./subword-nmt/learn_bpe.py -s 85000 > data/roen.bpe
```

Apply BPE
```
for prefix in corpus.clean newsdev2016 newstest2016
do
    ./subword-nmt/apply_bpe.py -c data/roen.bpe < data/$prefix.tc.ro > data/$prefix.bpe.ro
    ./subword-nmt/apply_bpe.py -c data/roen.bpe < data/$prefix.tc.en > data/$prefix.bpe.en
done
```

### Training a basic Nematus-style model

We can now train a model using our previously created training data. We use
`model` as our output folder and set the display freqency to 100
(i.e. a status update will be displayed every 100 mini-batch updates). Try to
inspect the `--help` option to determine what kind of model will be trained
by default, e.g. what's the default batch size? or what kind of encoder
is used? is there regularization?

```
mkdir -p model

./marian-dev/build/marian \
  --train-set data/corpus.clean.bpe.ro data/corpus.clean.bpe.en \
  --model model/model.npz \
  --disp-freq 100
```

You can kill the training process with the key shortcut `Ctrl+C`.

Let's try a couple of more advanced options (can you infer from the
help menu what these do?). But first, we will create a config file.

```
./marian-dev/build/marian \
  --type s2s \
  --train-set data/corpus.clean.bpe.ro data/corpus.clean.bpe.en \
  --valid-set data/newsdev2016.bpe.ro data/newsdev2016.bpe.en \
  --vocabs data/vocab.ro.yml data/vocab.en.yml \
  --model model/model.npz \
  --layer-normalization \
  --dim-vocabs 66000 50000 \
  --dynamic-batching --workspace 3000 \
  --dropout-rnn 0.2 --dropout-src 0.1 --moving-average \
  --early-stopping 5 --disp-freq 1000 \
  --log model/train.log --valid-log model/valid.log \
  --dump-config > model/config.yml
```

Now we can just use the config file to start our training process:
```
./marian-dev/build/marian -c model/config.yml
```

The training process will finish after a long time (these AWS GPUs are quite slow)
and will result in a model with similar performance to the pretrained one.

Continue with **[Part 2: Complex models](/examples/mtm2017/complex/)**

Continue with **[Part 3: A coding tutorial](/examples/mtm2017/code/)**
