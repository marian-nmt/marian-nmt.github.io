---
layout: docs
title: FAQ
permalink: /faq
icon: fa-life-ring
menu: 5
---

## FAQ

### General

{:.question}
#### Where can I get support?
There is a Google discussion group available at [https://groups.google.com/forum/#!forum/marian-nmt](https://groups.google.com/forum/#!forum/marian-nmt).
You can send questions to the group by e-mail: `marian-nmt@googlegroups.com`

{:.question}
#### Where can I report bugs?
I you believe you have encoutered a bug, please file an issue at [https://github.com/marian-nmt/marian/issues](https://github.com/marian-nmt/marian/issues)

{:.question}
#### How should I cite Marian?
Currently there is no proper publication for Marian yet (we are working on it!). For the moment please cite the following publication which
introduces Marian's predecessor AmuNMT:
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
There's also a bunch of publications that use Marian on our [publications](/publications) page (let us know if you want us to add yours).

### Translation

{:.question}
#### Are there recommended settings for translation?
We found that using length normalization with a penalty term of 0.6 and a beam size of 6 is usually best. This rougly follows the settings by Google from
their [transformer paper](https://arxiv.org/abs/1706.03762).
Assuming your model file is `model.npz` and your vocabulary is `vocab.src.yml` and `vocab.trg.yml`,
we recommend to use the following options:

```
./marian-decoder -m model.npz -v vocab.src.yml vocab.trg.yml -b 6 --normalize=0.6
```

{:.question}
#### Does Marian support batched translation?

Yes. This a feature introduced in Marian v1.1.0. Batched translation generates translation for whole mini-batches and significantly increases
translation speed (roughly by a factor of 10 or more). Assuming your model file is `model.npz` and your vocabulary is `vocab.src.yml` and `vocab.trg.yml`,
we recommend to use the following options to enable batched translation:
```
./marian-decoder -m model.npz -v vocab.src.yml vocab.trg.yml -b 6 --normalize=0.6 --mini-batch 64 --maxi-batch-sort src --maxi-batch 100 -w 2500
```
This does a number of things: firstly, it enables translation with a mini-batch size of 64, i.e. translating 64 sentences at once, with a beam-size of 6;
It preloads 100 maxi-batches and sorts them according to source sentence length, this allows for better packing of the batch and increases translation speed
quite a bit. We also added an option to use a length-normalization weight of 0.6 (this usually increases BLEU a bit) and set the working memory to 2500 MB. The
default working memory is 512 MB and Marian will increase it to match to requirements during translation, but pre-allocating memory makes it usually a bit faster.

To give you an idea, how much faster batched translation is compared to sentence-by-sentence translation we have collected a few numbers. Proper benchmarks will
be added soon. Below we have compiled the time it takes to translate the English-German WMT2013 test set with 3000 sentences using 4 Volta GPUs on AWS.

System | Single | Batched
-----------|--------|---------
Nematus-style Shallow RNN | 82.7s | 4.3s
Nematus-style Deep RNN | 148.5s | 5.9s
Google Transformer | 201.9s | 19.2s

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

{:.question}
#### First question

Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa.

{:.question}
#### Second question has _special_, **special**, `special` text

Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa.
Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa.
Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa.

### Decoding

{:.question}
#### Third question is a very very very very very very very very long

Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa.

{:.question}
#### Last question

Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa.
-->
