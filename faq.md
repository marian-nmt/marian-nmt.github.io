---
layout: docs
title: FAQ
permalink: /faq
icon: fa-life-ring
menu: 5
latex: true
---

## Table of contents

<div id="faq-nav"></div>

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
github repository](https://github.com/marian-nmt/marian).

{:.question}
#### Where can I get support?
There is a Google discussion group available at
[https://groups.google.com/forum/#!forum/marian-nmt](https://groups.google.com/forum/#!forum/marian-nmt).
You can send questions to the group by e-mail: `marian-nmt@googlegroups.com`.

{:.question}
#### Where can I report bugs?
I you believe you have encoutered a bug, please file an issue at
[https://github.com/marian-nmt/marian/issues](https://github.com/marian-nmt/marian/issues).

{:.question}
#### How should I cite Marian?
Please cite the following [Marian Demo paper](https://arxiv.org/abs/1804.00344)
if you use Marian (formerly AmuNMT) in your research:
```tex
@InProceedings{mariannmt,
  title     = {Marian: Fast Neural Machine Translation in {C++}},
  author    = {Junczys-Dowmunt, Marcin and Grundkiewicz, Roman and
               Dwojak, Tomasz and Hoang, Hieu and Heafield, Kenneth and
               Neckermann, Tom and Seide, Frank and Germann, Ulrich and
               Fikri Aji, Alham and Bogoychev, Nikolay and
               Martins, Andr\'{e} F. T. and Birch, Alexandra},
  booktitle = {Proceedings of ACL 2018, System Demonstrations},
  year      = {2018},
  address   = {Melbourne, Australia},
  url       = {https://arxiv.org/abs/1804.00344}
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
- Roman Grundkiewicz, University of Edinburgh, formerly Adam Mickiewicz University in Poznań
- Hieu Hoang, University of Edinburgh
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



<br/>
<!-- ///////////////////////////////////////////////////// -->
### Installation



{:.question}
#### Can Marian be run on Windows?
Yes, and both CPU and GPU builds are supported. Read more about Marian
compilation on Windows in
[https://github.com/marian-nmt/marian/vs/README.md](https://github.com/marian-nmt/marian/tree/master/vs/README.md).

{:.question}
#### Can I compile Marian without CUDA?
Yes. The CPU only version can be compiled by disabling the CUDA library with
the CMake flag `-DCOMPILE_CUDA=off`. This requires Intel MKL, see
[here](/docs/#cpu-version) for more details.

{:.question}
#### Why do I get an error `__CUDACC_VER__ is no longer supported`?
This issue is Boost related as some Boost versions are not compatible with CUDA
9.0+.  Updating Boost to 1.65.1+ should solve the compilation error.



<br/>
<!-- ///////////////////////////////////////////////////// -->
### Training



{:.question}
#### How do I enable multi-GPU training?
You only need to specify the device ids of the GPUs you want to use for training
(this also works with most other binaries) as `--devices 0 1 2 3` for training
on four GPUs.

See [the documentation on multi-GPU training](/docs/#multi-gpu-training) for
details.

{:.question}
#### Does Marian support training on CPU?
Yes, but we do not recommend that as it is much slower than training on GPU.

{:.question}
#### What are recommended training settings?
There is no simple answer as the choice of training settings and good
hyperparameters should depend on the model architecture, language pair, and
even training data.

You may check our Deep-RNN and Transformer examples for English-German
[here](/examples/#examples).

{:.question}
#### How do I chose mini-batch size, max-length and workspace memory?
Unfortunately this is quite involved and depends on the type of model, the available
GPU memory, the number of GPUs, a number of other parameters like the chosen
optimization algorithm, and the average or maximum sentence length in your
training corpus (which you should know!). See [this part of the
documentation](/docs/#workspace-memory) for deeper discussion.

{:.question}
#### How long do I need to train my models?
This is a difficult question. What I usually do as a rule of thumb is to use a
validation set as described [here](/docs/#validation) and the default settings
for `--early-stopping 10` as presented [here](/docs/#early-stopping).

{:.question}
#### What types of regularization are available?
Depending on the model type, Marian support multiple types of dropout as
described [here](/docs/#dropout).

Apart from dropout, we also provide `--label-smoothing` as suggested by
[Vaswani et al., 2017](https://arxiv.org/abs/1706.03762).

{:.question}
#### Do you have a Google-style transformer model?
Yes. Please take a look at our [transformer
example](https://github.com/marian-nmt/marian-examples/blob/master/transformer/README.md).
Files and scripts in this folder show how to train a Google-style transformer
model [Vaswani et al, 2017](https://arxiv.org/abs/1706.03762) on WMT-17 (?)
English-German data.

{:.question}
#### How do I train a model like in Edinburgh's WMT2017 submission?
Take a look at the examples we have prepared: {% github_link "Reconstructing
Edinburgh's WMT17 English-German system" marian-examples/wmt2017-uedin %} and
{% github_link "Reconstructing top English-German WMT17 system with Marian's
Transformer model" marian-examples/wmt2017-transformer %}.

{:.question}
#### How do I train a character-level model?
Convolutional character-level NMT models are not yet supported. We are working
on that.

{:.question}
#### How do I train a language model?
Set your monolingual training data file to `--train-sets` and use `--type
lm` for training a RNN language model or `--type lm-transformer` for training a
Transformer-based language model.

{:.question}
#### How do I train a multi-source model?
Provide two files with source sentences followed by the file with target
sentence to `--train-sets`, for instance `--train-set file.src1 file.src2
file.trg` and use `--type multi-s2s` or `--type multi-transformer` to train a
multi-source RNN-based model or multi-source Transformer model respectively.

There are also `shared-multi-s2s` and `shared-multi-transformer` model types,
which make encoders sharing their parameters.

{:.question}
#### What are the details of your multi-source model architectures?
The multi-source model architecture in Marian is described in [this
paper](https://arxiv.org/abs/1706.04138). In particular, Section 4.3.

{:.question}
#### Can I train a model with custom pretrained embeddings?
Yes. Please check the `--embedding-vectors` option.

{:.question}
#### What does the `--best-deep` option mean?
It is a shortcut for using [the Edinburgh deep RNN
configuration](https://arxiv.org/abs/1707.07631) being equivalent to:
```
--enc-type alternating --enc-cell-depth 2 --enc-depth 4 \
--dec-cell-base-depth 4 --dec-cell-high-depth 2 --dec-depth 4 \
--layer-normalization --tied-embeddings --skip
```

{:.question}
#### Does Marian support multi-node training?
Yes, but this is still an experimental feature. For details, see the documentation
[here](/docs/#multi-node-training).

{:.question}
#### Why there are so many files created while training?
Marian by default keeps the iteration files that may take up quite a bit of space.

When validation is enabled with any metric, you can use the following settings
to keep only one model per validation metric that is updated whenever the metric improves:

```
--valid-metrics perplexity translation
--valid-set data/valid.src data/valid.trg
--overwrite --keep-best
```



<br/>
<!-- ///////////////////////////////////////////////////// -->
### Validation




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



<br/>
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
#### Does Marian support CPU translation?
Yes, both `marian-decoder` and `amun` allows for decoding on CPU. Marian uses
Intel MKL for that, see more details [here](/docs/#cpu-version).

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
Not yet. This is a difficult issue for neural machine translation.

{:.question}
#### Can I access the attention weights?
Yes and no. `marian-decoder` can produce hard alignments from RNN-based NMT
models using `--alignment`.  `amun` has even more options for this, but is
restricted to a specific model type.

It is in principle not clear how to actually implement that for the transformer
as it has a lot of target-to-source attention matrices.

{:.question}
#### Can I generate n-best lists?
Yes. Just use `--n-best` and the set `--beam-size 6` for an n-best list size of
6.

{:.question}
#### How can I make the decoding faster?
Marian is already one of the fastest NMT toolkits available. You may further
speed up the decoding using different model optimization techniques taking an
inspiration from [our submission](https://arxiv.org/abs/1805.12096) to [the
WNMT17 shared task](https://sites.google.com/site/wnmt18/shared-task).



<br/>
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

Omitting the `--summary` option will print sentence-wise log probabilities.

{:.question}
#### Are Moses-style n-best lists supported?
Yes. Please use `--n-best` and set your n-best list file as a second argument
to the `--train-sets` option, the first argument should be a file with source
sentences.



<br/>
<!-- ///////////////////////////////////////////////////// -->
### Code



{:.question}
#### I would like to contribute to Marian. Where I should start?
Please take a look into
[CONTRIBUTING](https://github.com/marian-nmt/marian-dev/blob/master/CONTRIBUTING.md).

I usually recommend looking at the Iris and MNIST examples first and
familiarise yourself with the computational framework in Marian, and then
playing with more advanced models.

Any questions related to the code can be asked on [our discussion
group](https://groups.google.com/forum/#!forum/marian-nmt) or using [Github
issues](https://github.com/marian-nmt/marian-dev/issues).

{:.question}
#### Where can I find a documentation for developers?
We do not have a good code documentation yet. Many classes are documented using
Doxygen and the generated documentation is available
([here](/docs/marian/classes.html)).
