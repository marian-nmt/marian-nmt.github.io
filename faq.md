---
layout: docs
title: FAQ
permalink: /faq
icon: fa-life-ring
menu: 5
latex: true
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

{:.question}
#### Where do you announce updates?
See [changelog](https://github.com/marian-nmt/marian-dev/blob/master/CHANGELOG.md) for a curated list of changes or
follow us directly on twitter <a href="https://twitter.com/marian_nmt?ref_src=twsrc%5Etfw">@marian_nmt</a> for highlights.

{:.question}
#### Who is responsible for Marian?
See the list of [**marian-dev** contributors](https://github.com/marian-nmt/marian-dev/graphs/contributors) and [**marian** contributors](https://github.com/marian-nmt/marian/graphs/contributors).
As [**marian-dev**](https://github.com/marian-nmt/marian-dev) is our bleeding-edge development repository the main work on **marian** is happening there.
The [**marian**](https://github.com/marian-nmt/marian) repository is then updated with new versions.

Apart from that [**marian**](https://github.com/marian-nmt/marian) still contains code for **amun** our hand-written NMT decoder.
Contributions listed for that repository are mostly to **amun**.

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

### Training

{:.question}
#### What model types are currently available?

{:.question}
#### What are recommended training settings?

{:.question}
#### How do I train a model like in Edinburgh's WMT2017 submission?

{:.question}
#### How do I train a Google-style transformer model?

{:.question}
#### How do I enable multi-GPU training?

{:.question}
#### How do I chose mini-batch size, max-length and workspace memory?

{:.question}
#### How do I train a language model?

{:.question}
#### How do I train a multi-source model?

{:.question}
#### How do I set a validation set?

{:.question}
#### How long do I need to train my model?

{:.question}
#### What types of regularization are available?


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
translation speed (roughly by a factor of 10 or more). See [this documentation section](/docs/#batched-translation) for details.

{:.question}
#### Can Marian do model ensembling?

Yes, and you can even ensemble models of different types, for instance an Edinburgh-style deep RNN model and a Google Transformer model, or you can a
language model to the mix. See [here](/docs/#model-ensembling) for details.

{:.question}
#### Are there options to deal with placeholders or XML-tags?
No. This is a difficult issue for neural machine translation and we did not have the man power or motivation yet to deal with this.

{:.question}
#### Can I access the attention weights?
Yes and no. `amun` has options for this, but is restricted to a specific model type. `marian-decoder` does not provide this options yet,
but we are open to adding it if there is demand.

{:.question}
#### Can I generate n-best lists?
Yes. Just use `--n-best` and the set `--beam-size 6` for an n-best list size of 6.

### Scoring

{:.question}
#### How can I calculate the perplexity of a test set
Assuming your model file is `model.npz` and your vocabulary is `vocab.src.yml` and `vocab.trg.yml` and
your test set files are `test.src` and `test.trg` use the following command:

```
./marian-scorer -m model.npz -v vocab.src.yml vocab.trg.yml -t test.src test.trg --summary=perplexity
```

If your model had a different number of inputs (only one for a language model or three for a dual-source model)
you need to provide all the correct number of vocabularies and test set files in corresponding order.

Omitting the `--summary` option will print sentence-wise negative log probabilities.

{:.question}
#### Are Moses-style n-best lists supported?
Not yet. If you want to use the rescorer for for n-best list rescoring you need to extract the sentences to a
plain text file. If the model is a translation model you also need to create a source file that has the correct
source sentences in the right order and number, i.e. you need to repeat the source sentence as many times as there
are entries in the corresponding n-best list.


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
