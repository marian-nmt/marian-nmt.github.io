---
layout: docs
title: Training with Marian
permalink: /examples/training/
icon: fa-cogs
---

## Quick start

The files and scripts described in this section can be found in
{% github_link amunmt/examples/training %}. They have been adapted from the
Romanian-English sample from <https://github.com/rsennrich/wmt16-scripts>. We
also add the back-translated data from
<http://data.statmt.org/rsennrich/wmt16_backtranslations/> as described in
[Edinburgh's WMT16 paper](http://www.aclweb.org/anthology/W16-2323). The
resulting system should be competitive or even slightly better than reported in
that paper.

To execute the complete example type:

```
./run-me.sh
```

which downloads the Romanian-English training files and preprocesses them
(tokenization, truecasing, segmentation into subwords units).

To use with a different GPU than device 0 or more GPUs (here 0 1 2 3) type the
command below. Training time on 1 NVIDIA GTX 1080 GPU should be roughly 24
hours.

```
./run-me.sh 0 1 2 3
```

## Details

We omit a description of the preprocessing, individual steps can be retraced by
inspecting {% github_link amunmt/examples/training/scripts/preprocess.sh %}.

For training with Marian, the following command is being used:

```
../../build/marian \
    --model model/model.npz \
    --devices 0 --seed 0 \
    --train-sets data/corpus.bpe.ro data/corpus.bpe.en \
    --vocabs model/vocab.ro.yml model/vocab.en.yml \
    --dim-vocabs 66000 50000 \
    --dynamic-batching -w 3000 \
    --layer-normalization --dropout-rnn 0.2 --dropout-src 0.1 --dropout-trg 0.1 \
    --early-stopping 5 --moving-average \
    --valid-freq 10000 --save-freq 10000 --disp-freq 1000 \
    --valid-sets data/newsdev2016.bpe.ro data/newsdev2016.bpe.en \
    --valid-metrics cross-entropy valid-script \
    --valid-script-path ./scripts/validate.sh \
    --log model/train.log --valid-log model/valid.log
```

After training (the training should stop if cross-entropy on the validation set
stops improving) a final model `model/model.avg.npz` is created from the 4 best
models on the validation sets (by element-wise averaging). This model is used
to translate the WMT2016 dev set and test set with `amun`:

```
cat data/newstest2016.bpe.ro \
    | ../../build/amun \
        -c model/model.npz.amun.yml -m model/model.avg.npz \
        -d 0 -b 12 -n --mini-batch 10 --maxi-batch 1000 \
    | sed 's/\@\@ //g' | moses-scripts/scripts/recaser/detruecase.perl \
    > data/newstest2016.bpe.ro.output.postprocessed
```

after which BLEU scores for the dev and test set are reported. Results should
be somewhere in the area of:

```
newsdev2016:
BLEU = 36.27, 67.7/42.6/29.2/20.6 (BP=1.000, ratio=1.005, hyp_len=50740, ref_len=50483)

newstest2016:
BLEU = 35.01, 66.6/41.3/28.0/19.5 (BP=1.000, ratio=1.006, hyp_len=48800, ref_len=48531)
```

## Custom validation script

The validation script `scripts/validate.sh` is a quick example how to write a
custom validation script. The training pauses until the validation script
finishes executing. A validation script should not output anything to `stdout`
apart from the final single score (last line):

```bash
#!/bin/bash

# model prefix
prefix=model/model.npz

dev=data/newsdev2016.bpe.ro
ref=data/newsdev2016.tok.en

# decode
cat $dev | ../../build/amun -c $prefix.dev.npz.amun.yml -b 12 -n --mini-batch 10 --maxi-batch 100 2> /dev/null \
    | sed 's/\@\@ //g' | ./moses-scripts/scripts/recaser/detruecase.perl > $dev.output.postprocessed

# get BLEU
./moses-scripts/scripts/generic/multi-bleu.perl $ref < $dev.output.postprocessed \
    | cut -f 3 -d ' ' | cut -f 1 -d ','
```
