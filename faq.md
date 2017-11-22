---
layout: docs
title: FAQ
permalink: /faq
icon: fa-life-ring
menu: 5
latex: true
---

## Answers

### General

{:.question}
#### What is Marian?
Marian is a pure C++ neural machine translation toolkit. It supports training and translation of a number of popular NMT models. Underneath the NMT API lurkes
a quite mature deep learning engine with no external dependencies other than boost and Nvidia's CUDA (with optional CUDNN for convolutional networks).

Due to its self-contained nature, it is quite easy to optimize Marian for NMT specific tasks which results in one of the more efficient NMT toolkits available.
Take a look at the [benchmarks](/features/#benchmarks).

{:.question}
#### Where can I get Marian?
Follow the steps in [quick start](/quickstart) to get install Marian from our github repository [https://github.com/marian-nmt/marian](https://github.com/marian-nmt/marian)

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

{:.question}
#### What's up with the name?
Marian has been named in honour of the Polish crypotologist [Marian Rejewski](https://en.wikipedia.org/wiki/Marian_Rejewski)
who reconstructed the German military Enigma cipher machine in 1932.

[Marcin](https://github.com/emjotde) (the creator of the Marian toolkit) was born in the same Polish city as Marian Rejewski (Bydgoszcz), taught a bit of mathematics at Marian Rejewski's
secondary school in Bydgoszcz and finally ended up studying mathematics at Adam Mickiewicz University in Poznań, at Marian Rejewski's old faculty.

The name started out as a joke, but was made official later by public demand.

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
#### How do I train a language model?

{:.question}
#### How do I train a multi-source model?

{:.question}
#### How do I enable multi-GPU training?

You only need to specify the device ids of the GPUs you want to use for training
(this also works with most other binaries) as `--devices 0 1 2 3` for training
on four GPUs. There is no automatic detection of GPUs for now.

By default, this will use asynchronous SGD (or rather ADAM). For the deeper models
and the transformer model, we found async SGD to be unreliable and you may want
to use a synchronous SGD variant by setting `--sync-sgd`.

For asynchronous SGD, the mini-batch size is used locally, i.e. `--mini-batch 64`
means 64 sentences per GPU worker.

For synchronous SGD, the mini-batch size is used
globally and will be divided across the number of workers. This means that for
synchronous SGD the effective mini-batch can be set N times larger for N GPUs. A
mini-batch size of `--mini-batch 256` will mean a mini-batch of 64 per worker if
four GPUs are used. This choice makes sense when you realize that synchronous
SGD is essentially working like a single GPU training process with N times more
memory. Larger mini-batches in a synchronous setting result in quite stable
training.

{:.question}
#### How do I chose mini-batch size, max-length and workspace memory?
Unfortunately this is quite involved and depends on the type of model, the available
GPU memory, the number of GPUs, a number of other parameters like the chosen
optimization algorithm, and the average or maximum sentence length in your
training corpus (which you should know!).

The options `--workspace 4000` sets the size of the memory available for the forward
and backward step of the training procedure. This does not include model size and
optimizer parameters that are allocated outsize workspace. Hence you cannot allocate
all GPU memory to workspace. If you are not happy with default values this is a trial and error
process.

Setting `--mini-batch 64 --max-length 100` will generate batches that contain
always 64 sentences (or less if the corpus is smaller) of up to a length of 100
tokens. Sentences longer than that are filtered out. Marian will grow workspace memory
if required and potentially exceed available memory, resulting in a crash. Workspace
memory is always rounded to multiples of 512 MB.

`--mini-batch-fit` overrides the specified mini-batch size and automatically choses
the largest mini-batch for a given sentence length that fits the specified memory. When
`--mini-batch-fit` is set, memory requirements are guaranteed to fit into the specified
workspace. Choosing a too small workspace will result in small mini-batches which can prohibit
learning.

##### My rules of thumb:

For shallow models I usually set the working memory to values between 3500 and 6000 (MB),
e.g. `--workspace 5500` and then use `--mini-batch-fit` which automatically tries to make
the best use of the specified memory size, mini-batch size and sentence length.

For very deep models, I first set all other parameters like `--max-length 100`, model type, depth etc.
Next I use `--mini-batch-fit` and try to max out `--workspace` until I get a crash due to insufficient memory. I then
revert to the last workspace size that did not crash. Since setting `--mini-batch-fit` guarantees that memory
will not grow during training due to batch-size this should result in a stable training run and maximal batch size.

{:.question}
#### How do I use a validation set?

Just provide `--valid valid.src valid.trg`. Be default this provide sentence-wise
normalized cross-entropy scores for the validation set every 10,000 iterations.
You can change the validation frequency to, say 5000, with `--valid-freq 5000` and
the display frequency to 500 with `--disp-freq 500`.

**Attention:** the validation set needs to have been preprocessed in exactly the same
manner as your training data.

{:.question}
#### What types of validation scores are available?
Be default we report sentence-wise normalized cross-entropy, but you can specify
different and more than one metrics, for example `--valid-metrics perplexity ce-mean-words translation`
which will report word-wise normalized perplexity, word-wise normalized cross-entropy and will
run in-process translation of the validation set to be scored with an external validation script.
See [this part of the documentation](/docs/#validation) for more details.

{:.question}
#### How long do I need to train my models?
This is a difficult question. What I usually do as a rule of thumb is to use a
validation set as described above and the default settings for `--early-stopping 10`.
This means that training will finish if the first specified metric in `--valid-metrics`
did not improve (stalled) for 10 consecutive validation steps. Usually this will
signal convergence or --- if the scores get worse with later validation steps ---
potential overfitting.

{:.question}
#### What types of regularization are available?
The numeric values in this answer are only provided as examples.

Depending on the model type, Marian support multiple types of dropout. For
RNN-based models it supports the `--dropout-rnn 0.2` option which uses
variational dropout on all RNN inputs and recursive states.

There is also `--dropout-src 0.1` and `--dropout-trg 0.1` which drops out entire
source and target word positions, respectively. This is an options we found to
be useful for monolingual settings.

For the transformer model the equivalent of `--dropout-rnn 0.2` is `--transformer-dropout 0.2`.

Apart from dropout, we also provide `--label-smoothing 0.1` as suggested by [Vaswani et
  al., 2017](https://arxiv.org/abs/1706.03762).

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
#### How can I calculate the perplexity of a test set?
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
