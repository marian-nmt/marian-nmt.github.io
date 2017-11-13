---
layout: docs
title: Documentation
permalink: /docs/
icon: fa-file-code-o
menu: 3
---

## Tools overview

Marian toolkit provides the following tools:

* `marian`: for training models of all types
* `marian-decoder`: for GPU translation with models of all types
* `marian-server`: the web-socket server providing GPU translation
* `marian-scorer`: the rescoring tool
* `amun`: for CPU and GPU translation with Amun and certain Nematus models

### Model types

Available model types:
* `s2s`: Default model type, which supports most of the features provided by
  the toolkit. The architecture is equivalent to the
  [Nematus](https://github.com/EdinburghNLP/nematus) models ([Senrich et al.,
  2017](https://arxiv.org/abs/1703.04357)), which use the RNN
  encoder-decoder architecture with an attention mechanism, but not fully
  compatible with them. Certain models of this type can be converted to models
  of type Amun.
* `multi_s2s`: Model of type `s2s`, which uses two or more encoders enabling
  multi-source neural translation.
* `transformer`: A new model based on [_Attention is all you need_, Vaswani et
  al., 2017](https://arxiv.org/abs/1706.03762).
* `nematus`: Model architecture is equivalent to deep models created by
  Edinburgh MT group for WMT 2017 with Nematus. This is the only model type
  supporting models trained with the Nematus toolkit and enabled layer
  normalization. Can be decoded with the Amun tool as _nematus2_ model type.
* `amun`: Model architecture is equivalent to the DL4MT models used in Nematus.
  Can be decoded with Amun tool as _nematus_ model type.
* `lm`: An RNN language model.



## Training

For training NMT models, you want to use `marian` command.
Assuming `corpus.en` and `corpus.ro` are corresponding and preprocessed files
of a English-Romanian parallel corpus, the following command will create a
Nematus-compatible neural machine translation model:

    ./build/marian \
        --train-sets corpus.en corpus.ro \
        --vocabs vocab.en vocab.ro \
        --model model.npz

Training settings can be provided in the configuration file:

```yaml
# config.yml
train-sets:
  - corpus.en
  - corpus.ro
vocabs:
  - vocab.en
  - vocab.ro
model: model.npz
```

which simplifies the command to:

    ./build/marian -c config.yml

Command-line options overwrite options stored in the configuration file.

### Multi-GPU training

Use option `--devices` to specify on which GPU devices the model should be
trained:

    ./build/marian \
        --devices 0 1 2 3 \
        --train-sets corpus.en corpus.ro \
        --vocabs vocab.en vocab.ro \
        --model model.npz

The asynchronous SGD is used by default, while the synchronous version can be
enabled with `--sync-sgd`. The latter scales worse on multiple devices, but may
allow to achieve better cross-entropy scores.

### Validation

It is useful to monitor the performance of your model during training on
held-out data.

This is a minimum example of how to validate the model using cross-entropy and
BLEU score:

    ./build/marian \
        --train-sets corpus.en corpus.ro \
        --vocabs vocab.en vocab.ro \
        --model model.npz \
        --valid-set dev.en dev.ro \
        --valid-metrics cross-entropy translation \
        --valid-script-path validate.sh

where _validate.sh_ is a bash script, which takes the file with output
translation of `dev.en` as the first argument (i.e. `$1`) and returns the BLEU
score, e.g.:

```sh
# validate.sh
cat $1 | ./postprocess.sh 2>/dev/null > file.out
./moses-scripts/scripts/generic/multi-bleu-detok.perl file.ref < file.out 2>/dev/null \
    | sed -r 's/BLEU = ([0-9.]+),.*/\1/'
```

### Decaying learning rate

Manipulation of learning rate during the training may result in better
convergence and higher-quality translations.

Marian supports various strategies for decaying learning rate
(`--lr-decay-strategy` option):
* `epoch`: learning rate will be decayed after each epoch starting from epoch
  specified with `--lr-decay-start`
* `batches`: learning rate will be decayed every `--lr-decay-freq` batches
  starting after the batch specified with `--lr-decay-start`
* `stalled`: learning rate will be decayed every time when the first validation
  metric does not improve for `--lr-decay-start` consecutive validation steps
* `epoch+stalled`: learning rate will be decayed after the specified number of
  epochs or stalled validation steps, whichever comes first. The option
  `--lr-decay-start` takes two numbers: for epochs and stalled validation
  steps, respectively
* `batches+stalled`: as previous strategy, but batches are used instead of
  epochs

Decay factor for learning rate can be specified with `--lr-decay`.



## Translation

All model types can be decoded with `marian-decoder` and `marian-server`
command.  Only models of type Amun and certain models of type Nematus can be
used with `amun` command.

### Marian decoder

Currently, `marian-decoder` supports only translation on GPU. The CPU version
of Marian is upcoming.

Basic usage:

    ./build/marian-decoder -m model.npz -v vocab.en vocab.ro < input.txt

#### Model ensembling

Models of various types and architectures can be ensembled if they use the same
vocabularies:

    ./build/marian-decoder \
        --models model1.npz model2.npz model3.npz \
        --weights 1.0 1.0 1.0 \
        --vocabs vocab.en vocab.ro < input.txt

#### Models trained with Nematus

Certain types of models trained with Nematus, for example the [Edinburgh WMT17
deep models](http://data.statmt.org/wmt17_systems/) can be decoded with
`marian-decoder`.  As such models do not include model parameters specifying
the model architecture, all parameters have to be set with command-line
options.
For example, for the [de-en model](http://data.statmt.org/wmt17_systems/en-de/)
this would be:

    ./build/marian-decoder \
        --type nematus \
        --models model/en-de/model.npz \
        --vocabs model/en-de/vocab.en.json model/en-de/vocab.de.json \
        --dim-vocabs 51100 74383 \
        --enc-depth 1 \
        --enc-cell-depth 4 \
        --enc-type bidirectional \
        --dec-depth 1 \
        --dec-cell-base-depth 8 \
        --dec-cell-high-depth 1 \
        --dec-cell gru-nematus --enc-cell gru-nematus \
        --tied-embeddings true \
        --layer-normalization true

Alternatively, the model parameters can be added into the model _.npz_ file
based on the Nematus _.json_ file using the script: {% github_link
marian-dev/scripts/contrib/inject_model_params.py %}, e.g.:

    python inject_model_params.py -m model.npz -j model.npz.json



### Marian web server

The `marian-server` command starts a web-socket server for translation.
It uses the same command-line options as `marian-decoder`.
The only addition is `--port` option, which specifies the port number:

    ./build/marian-server --port 8080 -m model.npz -v vocab.en vocab.ro

An example client written in Python is {% github_link
marian-dev/scripts/server/client_example.py %}:

    ./scripts/server/client_example.py -p 8080 < input.txt

### Amun

Amun is a translation tool for certain models of `amun` and `nematus` model
types. Translation can be performed on GPU or CPU or both.

Basic usage:

    ./marian/build/amun -m model.npz -s vocab.en -t vocab.ro <<< "This is a test ."



## Scorer

The `marian-scorer` tool is used for scoring (or re-scoring) parallel sentences
provided as plain texts in two corresponding files:

    ./build/marian-scorer -m model.npz -v vocab.ro vocab.en -t file.ro file.en

A cross-entropy score for each sentence pair is returned by default.  The
scorer can be also used to summarize scores (option `--summary`), so it can
calculate cross-entropy and perplexity for a whole test set and report it at
the end.

### N-best lists

The scorer does not support n-best lists as an input yet.



## Command-line options

* [marian](/docs/cmd/marian)
* [marian-decoder](/docs/cmd/marian-decoder)
* [marian-server](/docs/cmd/marian-server)
* [marian-scorer](/docs/cmd/marian-scorer)
* [amun](/docs/cmd/amun)



## Code documentation

[The code documentation for Marian toolkit](/docs/marian/classes.html) is
generated using Doxygen. The newest version can be generated locally with CMake:

    mkdir -p build && cd build && cmake .. && make doc

