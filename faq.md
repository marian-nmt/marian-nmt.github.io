---
layout: docs
title: FAQ
permalink: /faq
icon: fa-life-ring
menu: 5
latex: true
---

## Answers

<!-- ///////////////////////////////////////////////////// -->
### General

{:.question}
#### What is Marian?
Marian is a pure C++ neural machine translation toolkit. It supports training
and translation of a number of popular NMT models. Underneath the NMT API
lurkes a quite mature deep learning engine with no external dependencies other
than boost and Nvidia's CUDA (with optional CUDNN for convolutional networks).

Due to its self-contained nature, it is quite easy to optimize Marian for NMT
specific tasks which results in one of the more efficient NMT toolkits
available.  Take a look at the [benchmarks](/features/#benchmarks).

{:.question}
#### Where can I get Marian?
Follow the steps in [quick start](/quickstart) to get install Marian from [our
github repository](https://github.com/marian-nmt/marian)

{:.question}
#### Where can I get support?
There is a Google discussion group available at
[https://groups.google.com/forum/#!forum/marian-nmt](https://groups.google.com/forum/#!forum/marian-nmt).
You can send questions to the group by e-mail: `marian-nmt@googlegroups.com`

{:.question}
#### Where can I report bugs?
I you believe you have encoutered a bug, please file an issue at
[https://github.com/marian-nmt/marian/issues](https://github.com/marian-nmt/marian/issues)

{:.question}
#### How should I cite Marian?
Currently there is no proper publication for Marian yet (we are working on
it!). For the moment please cite the following publication which introduces
Marian's predecessor AmuNMT:
```
@InProceedings{junczys2016neural,
  title     = {Is Neural Machine Translation Ready for Deployment? A Case Study
               on 30 Translation Directions},
  author    = {Junczys-Dowmunt, Marcin and Dwojak, Tomasz and Hoang, Hieu},
  booktitle = {Proceedings of the 9th International Workshop on Spoken Language
               Translation (IWSLT)},
  year      = {2016},
  address   = {Seattle, WA},
  url       = {http://workshop2016.iwslt.org/downloads/IWSLT_2016_paper_4.pdf}
}
```
There's also a bunch of publications that use Marian on our
[publications](/publications) page (let us know if you want us to add yours).

{:.question}
#### Where do you announce updates?
See
[changelog](https://github.com/marian-nmt/marian-dev/blob/master/CHANGELOG.md)
for a curated list of changes or follow us directly on twitter <a
href="https://twitter.com/marian_nmt?ref_src=twsrc%5Etfw">@marian_nmt</a>
for highlights.

{:.question}
#### Who is responsible for Marian?
See the list of [**marian-dev**
contributors](https://github.com/marian-nmt/marian-dev/graphs/contributors) and
[**marian**
contributors](https://github.com/marian-nmt/marian/graphs/contributors).
As [**marian-dev**](https://github.com/marian-nmt/marian-dev) is our
bleeding-edge development repository the main work on **marian** is happening
there.
The [**marian**](https://github.com/marian-nmt/marian) repository is then
updated with new versions.

Apart from that [**marian**](https://github.com/marian-nmt/marian) still
contains code for **amun** our hand-written NMT decoder.  Contributions listed
for that repository are mostly to **amun**.

The list of contributors so far:

- Marcin Junczys-Dowmunt, formerly Adam Mickiewicz University in Poznań and University of Edinburgh
- Roman Grundkiewicz, University of Edinburgh and Adam Mickiewicz University in Poznań
- Hieu Hoang
- Tomasz Dwojak, Adam Mickiewicz University in Poznań, formerly University of Edinburgh
- Ulrich German, University of Edinburgh
- Alham Aji, University of Edinburgh
- Nikolay Bogoychev, University of Edinburgh
- Kenneth Heafield, University of Edinburgh
- Alexandra Birch, University of Edinburgh

{:.question}
#### What's up with the name?
Marian has been named in honour of the Polish crypotologist [Marian
Rejewski](https://en.wikipedia.org/wiki/Marian_Rejewski) who reconstructed the
German military Enigma cipher machine in 1932.

[Marcin](https://github.com/emjotde) (the creator of the Marian toolkit) was
born in the same Polish city as Marian Rejewski (Bydgoszcz), taught a bit of
mathematics at Marian Rejewski's secondary school in Bydgoszcz and finally
ended up studying mathematics at Adam Mickiewicz University in Poznań, at
Marian Rejewski's old faculty.

The name started out as a joke, but was made official later by public demand.


<!-- ///////////////////////////////////////////////////// -->
### Training

<!--
{:.question}
#### What model types are currently available?

{:.question}
#### What are recommended training settings?
-->

{:.question}
#### How do I enable multi-GPU training?
You only need to specify the device ids of the GPUs you want to use for training
(this also works with most other binaries) as `--devices 0 1 2 3` for training
on four GPUs.

See [the documentation on multi-GPU training](/docs/#multi-gpu-training) for
details.

{:.question}
#### How do I chose mini-batch size, max-length and workspace memory?
Unfortunately this is quite involved and depends on the type of model, the available
GPU memory, the number of GPUs, a number of other parameters like the chosen
optimization algorithm, and the average or maximum sentence length in your
training corpus (which you should know!). See [this part of the
documentation](/docs/#workspace-memory) for deeper discussion.

{:.question}
#### How do I use a validation set?
Just provide `--valid valid.src valid.trg`. Be default this provide sentence-wise
normalized cross-entropy scores for the validation set every 10,000 iterations.
You can change the validation frequency to, say 5000, with `--valid-freq 5000` and
the display frequency to 500 with `--disp-freq 500`.
See [here](/docs/#validation) for more information.

**Attention:** the validation set needs to have been preprocessed in exactly the same
manner as your training data.

{:.question}
#### What types of validation scores are available?
By default we report sentence-wise normalized cross-entropy, but you can
specify different and more than one metrics.

For example `--valid-metrics perplexity ce-mean-words translation` will
report word-wise normalized perplexity, word-wise normalized cross-entropy and
will run in-process translation of the validation set to be scored with an
external validation script.

{:.question}
#### How to display BLEU, METEOR or TER scores for a validation set?
Currently this is possible only by using an external validation script.
Such a script takes a file with the translation of the valiadion set as an
intput and should run an external tool and return the score.
See [here](/docs/#validation) for more information.

{:.question}
#### How long do I need to train my models?
This is a difficult question. What I usually do as a rule of thumb is to use a
validation set as described [here](/docs/#validation) and the default settings
for `--early-stopping 10` as presented [here](/docs/#early-stopping).

{:.question}
#### What types of regularization are available?
Depending on the model type, Marian support multiple types of dropout as
described [here in the documentation](/docs/#dropout).

Apart from dropout, we also provide `--label-smoothing` as suggested by
[Vaswani et al., 2017](https://arxiv.org/abs/1706.03762).

{:.question}
#### Do you have a Google-style transformer model?
Please take a look at our [transformer
example](https://github.com/marian-nmt/marian-examples/blob/master/transformer/README.md).
Files and scripts in this folder show how to train a Google-style transformer
model [Vaswani et al, 2017](https://arxiv.org/abs/1706.03762) on WMT-17 (?)
English-German data.

{:.question}
#### How do I train a model like in Edinburgh's WMT2017 submission?
Re-using the transformer example from above, you can train a model similar to
[Edinburgh's WMT2017 submission](http://www.statmt.org/wmt17/pdf/WMT39.pdf) with the following settings:

```
../build/marian \
    --model model/model.npz --type s2s \
    --train-sets data/corpus.bpe.en data/corpus.bpe.de \
    --max-length 100 \
    --vocabs model/vocab.ende.yml model/vocab.ende.yml \
    --mini-batch-fit -w 7000 --maxi-batch 1000 \
    --early-stopping 10 \
    --beam-size 6 --normalize 0.6 \
    --log model/train.log --valid-log model/valid.log \
    --enc-type bidirectional --enc-depth 1 --enc-cell-depth 4 \
    --dec-depth 1 --dec-cell-base-depth 8 --dec-cell-high-depth 1 \
    --tied-embeddings-all --layer-normalization \
    --dropout-rnn 0.1 --label-smoothing 0.1 \
    --learn-rate 0.0003 --lr-warmup 16000 --lr-decay-inv-sqrt 16000 --lr-report \
    --optimizer-params 0.9 0.98 1e-09 --clip-norm 5 \
    --tied-embeddings-all \
    --devices $GPUS --sync-sgd --seed 1111 \
    --valid-freq 5000 --save-freq 5000 --disp-freq 500 \
    --valid-metrics cross-entropy perplexity translation \
    --valid-sets data/valid.bpe.en data/valid.bpe.de \
    --valid-script-path ./scripts/validate.sh \
    --valid-translation-output data/valid.bpe.en.output --quiet-translation \
    --valid-mini-batch 64
```

The variable $GPUS would hold the GPU ids, for instance GPUS="0 1 2 3". As before
you can increase the workspace if more GPU RAM is available. If you train models
for ensembling remember to change the seed between training runs to initialize
models differently.

We will add an example to our examples repository.

{:.question}
#### How do I train a language model?

{:.question}
#### How do I train a multi-source model?


<!-- ///////////////////////////////////////////////////// -->
### Translation

{:.question}
#### Are there recommended settings for translation?
We found that using length normalization with a penalty term of 0.6 and a beam
size of 6 is usually best:

```
./marian-decoder -m model.npz -v vocab.src.yml vocab.trg.yml -b 6 --normalize=0.6
```

Look at [the translation documenation](/docs/#translation) for more advices.

{:.question}
#### Does Marian support batched translation?
Yes. This a feature introduced in Marian v1.1.0. Batched translation generates
translation for whole mini-batches and significantly increases translation
speed (roughly by a factor of 10 or more). See [this part of the
documentation](/docs/#batched-translation) for details.

{:.question}
#### Can Marian do model ensembling?
Yes, and you can even ensemble models of different types, for instance an
Edinburgh-style deep RNN model and a Google Transformer model, or you can a
language model to the mix. See [here](/docs/#model-ensembling) for details.

{:.question}
#### Are there options to deal with placeholders or XML-tags?
No. This is a difficult issue for neural machine translation and we did not
have the man power or motivation yet to deal with this.

{:.question}
#### Can I access the attention weights?
Yes and no. `amun` has options for this, but is restricted to a specific model
type. `marian-decoder` does not provide this options yet, but we are open to
adding it if there is demand.

{:.question}
#### Can I generate n-best lists?
Yes. Just use `--n-best` and the set `--beam-size 6` for an n-best list size of
6.



<!-- ///////////////////////////////////////////////////// -->
### Scoring

{:.question}
#### How can I calculate the perplexity of a test set?
You may adapt the following command for your model file, vocabularies and a
test set:

```
./marian-scorer -m model.npz -v vocab.src.yml vocab.trg.yml -t test.src test.trg --summary=perplexity
```

If your model had a different number of inputs (only one for a language model
or three for a dual-source model) you need to provide all the correct number of
vocabularies and test set files in corresponding order.

Omitting the `--summary` option will print sentence-wise negative log
probabilities.

{:.question}
#### Are Moses-style n-best lists supported?
Not yet. If you want to use the rescorer for for n-best list rescoring you need
to extract the sentences to a plain text file. If the model is a translation
model you also need to create a source file that has the correct source
sentences in the right order and number, i.e. you need to repeat the source
sentence as many times as there are entries in the corresponding n-best list.


<!--
### Training

System | 2013 | 2014 | 2015 | 2016
-----------|--------|---------|--------|-------
Edinburgh Deep RNN ([Micelli Barone et al 2017](https://arxiv.org/pdf/1707.07631.pdf)) | - | 23.4 | 26.0 | 31.0
Transformer 12-layers ([Ramachandran et al. 2017](https://arxiv.org/pdf/1710.05941.pdf)) | 26.1* | 27.8* | 29.8* | 33.3*
**Marian Transformer 6-layers** (epoch 27!) | 25.5* | 26.7 | 29.5 | 33.2
**Marian Transformer 6-layers** (epoch 43!) | 25.5* | 26.9 | 29.2 | 33.4
**Marian Edinburgh Deep RNN** (epoch 9) | 24.8* | 24.9 | 28.4 | 32.7
**Marian Edinburgh Deep RNN** (epoch 16) | 25.0* | 25.2 | 28.4 | 32.6

-->
