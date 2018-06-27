---
layout: docs
title: Documentation
permalink: /docs/
icon: fa-file-code-o
menu: 3
latex: true
---

## Overview and command-line options
Marian toolkit provides the following tools (click on the name for a list of
command line options):

* [marian](/docs/cmd/marian): for training models of all types
* [marian-decoder](/docs/cmd/marian-decoder): for GPU translation with models of all types
* [marian-server](/docs/cmd/marian-server): a web-socket server providing GPU translation
* [marian-scorer](/docs/cmd/marian-scorer): a tool for rescoring
* [amun](/docs/cmd/amun): for CPU and GPU translation with Amun and certain Nematus models


### Model types

- `s2s`: An RNN-based encoder-decoder model with attention mechanism. The
  architecture is equivalent to the
  [DL4MT](https://github.com/nyu-dl/dl4mt-tutorial) or
  [Nematus](https://github.com/EdinburghNLP/nematus) models ([Senrich et al.,
  2017](https://arxiv.org/abs/1703.04357)), but not compatible with them as we
  use custom names for matrices and our layer normalization is implemented
  differently. Specific models of this type can be converted to Amun models.
- `transformer`: A new model originally proposed by Google [(Vaswani et al.,
  2017)](https://arxiv.org/abs/1706.03762) based solely on attention
  mechanisms.
- `multi-s2s`: As `s2s`, but uses two or more encoders allowing multi-source
  neural machine translation.
- `multi-transformer`: As `transformer`, but uses multiple encoders.
- `amun`: Equivalent to Nematus models unles layer normalization is used. Can
  be decoded with Amun as _nematus_ model type.
- `nematus`: Equivalent to deep RNN-based  encoder-decoder models developed by
  the Edinburgh MT group for WMT 2017 using Nematus toolkit. The only model
  type that supports models trained with the Nematus-style layer normalization.
  Can be decoded with Amun as _nematus2_ model type.
- `lm`: An RNN language model.
- `lm-transformer`: An transformer-based language model.



## Installation

Clone a fresh copy from github:

    git clone https://github.com/marian-nmt/marian

The project is a standard CMake out-of-source build:

    cd marian
    mkdir build
    cd build
    cmake ..
    make -j

If run for the first time, this will also download {% github_link marian-dev %}
--- the training framework for Marian.

### Custom Boost

Download, compile and install Boost:
```
wget https://dl.bintray.com/boostorg/release/1.64.0/source/boost_1_64_0.tar.gz
tar zxvf boost_1_64_0.tar.gz
cd boost_1_64_0
./bootstrap.sh
./b2 -j16 --prefix=$(pwd) --libdir=$(pwd)/lib64 --layout=system link=static install
```

To compile Marian training framework with your custom Boost installation:
```
cd /path/to/marian-dev
mkdir build
cd build
cmake .. -DBOOST_ROOT=/path/to/boost_1_64_0
make -j16
```

Tested on Ubuntu 16.04.3 LTS.

### Non-default CUDA

Specify the path to your CUDA root directory via CMake:
```
cd /path/to/marian-dev
mkdir build
cd build
cmake .. -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-9.1
make -j16

```



## Training

For training NMT models, you want to use `marian` command.
Assuming `corpus.en` and `corpus.ro` are corresponding and preprocessed files
of a English-Romanian parallel corpus, the following command will create a
Nematus-compatible neural machine translation model:

    ./build/marian \
        --train-sets corpus.en corpus.ro \
        --vocabs vocab.en vocab.ro \
        --model model.npz

Command options can be also specified in a configuration file in YAML format:

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

For multi-GPU training You only need to specify the device ids of the GPUs you
want to use for training (this also works with most other binaries) as
`--devices 0 1 2 3` for training on four GPUs. There is no automatic detection
of GPUs for now.

By default, this will use asynchronous SGD (or rather ADAM). For the deeper models
and the transformer model, we found async SGD to be unreliable and you may want
to use a synchronous SGD variant by setting `--sync-sgd`.

For asynchronous SGD, the mini-batch size is used locally, i.e. `--mini-batch 64`
means 64 sentences per GPU worker.

For synchronous SGD, the mini-batch size is used globally and will be divided
across the number of workers. This means that for synchronous SGD the effective
mini-batch can be set N times larger for N GPUs. A mini-batch size of
`--mini-batch 256` will mean a mini-batch of 64 per worker if four GPUs are
used. This choice makes sense when you realize that synchronous SGD is
essentially working like a single GPU training process with N times more
memory. Larger mini-batches in a synchronous setting result in quite stable
training.


### Validation

It is useful to monitor the performance of your model during training on
held-out data. Just provide `--valid valid.src valid.trg` for that. By default
this provide sentence-wise normalized cross-entropy scores for the validation
set every 10,000 iterations.  You can change the validation frequency to, say
5000, with `--valid-freq 5000` and the display frequency to 500 with
`--disp-freq 500`.

**Attention:** the validation set needs to have been preprocessed in exactly
the same manner as your training data.

A minimum example of how to validate the model using cross-entropy and
BLEU score:

    ./build/marian \
        --train-sets corpus.en corpus.ro \
        --vocabs vocab.en vocab.ro \
        --model model.npz \
        --valid-set dev.en dev.ro \
        --valid-metrics cross-entropy translation \
        --valid-script-path validate.sh

where `validate.sh` is a bash script, which takes the file with output
translation of `dev.en` as the first argument (i.e. `$1`) and returns the BLEU
score, for example:

```sh
# validate.sh
./postprocess.sh < $1 > file.out 2>/dev/null
./moses-scripts/scripts/generic/multi-bleu-detok.perl file.ref < file.out 2>/dev/null \
    | sed -r 's/BLEU = ([0-9.]+),.*/\1/'
```


### Early stopping

Early stopping is a common technique for deciding when to stop training the
model based on a heuristic involving a validation set.

By default we use early stopping with patience of 10, i.e. `--early-stopping
10`. This means that training will finish if the first specified metric in
`--valid-metrics` did not improve (stalled) for 10 consecutive validation
steps. Usually this will signal convergence or --- if the scores get worse with
later validation steps --- potential overfitting.


### Dropouts

The numeric values are only provided as examples.

Depending on the model type, Marian support multiple types of dropout.  For
RNN-based models it supports the `--dropout-rnn 0.2` option which uses
variational dropout on all RNN inputs and recursive states.

There is also `--dropout-src 0.1` and `--dropout-trg 0.1` which drops out
entire source and target word positions, respectively. This is an options we
found to be useful for monolingual settings.

For the transformer model the equivalent of `--dropout-rnn 0.2` is
`--transformer-dropout 0.2`.

Apart from dropout, we also provide `--label-smoothing 0.1` as suggested by
[Vaswani et al., 2017](https://arxiv.org/abs/1706.03762).


### Decaying learning rate

Manipulation of learning rate during the training may result in better
convergence and higher-quality translations.

Marian supports various strategies for decaying learning rate
(`--lr-decay-strategy` option):
- `epoch`: learning rate will be decayed after each epoch starting from epoch
  specified with `--lr-decay-start`
- `batches`: learning rate will be decayed every `--lr-decay-freq` batches
  starting after the batch specified with `--lr-decay-start`
- `stalled`: learning rate will be decayed every time when the first validation
  metric does not improve for `--lr-decay-start` consecutive validation steps
- `epoch+stalled`: learning rate will be decayed after the specified number of
  epochs or stalled validation steps, whichever comes first. The option
  `--lr-decay-start` takes two numbers: for epochs and stalled validation
  steps, respectively
- `batches+stalled`: as `epoch+stalled`, but the total number of batches is
  taken into account instead of epochs

Decay factor for learning rate can be specified with `--lr-decay`.



### Data weighting

Data weighting is commonly used as a domain adaptation technique, which weights
each data item according to its proximity to the in-domain data.  Marian
supports sentence and word-level data weighting strategies.

Data weighting requires providing a file with weights.  In sentence weighting
strategy, each line of that file contains a real-value weight:

```
./build/marian \
    -t corpus.{en,de} -v vocab.{en,de} -m model.npz \
    --data-weighting-type sentence --data-weighting weights.txt
```

To use word weighting you should choose `--data-weighting-type word`, and each
line of the weight file should contain as many real-value weights as there are
words in the corresponding target training sentence.


### Workspace memory

The choice of workspace memory, mini-batch size and max-length is quite
involved and depends on the type of model, the available GPU memory, the number
of GPUs, a number of other parameters like the chosen optimization algorithm,
and the average or maximum sentence length in your training corpus (which you
should know!).

The options `--workspace 4000` sets the size of the memory available for the
forward and backward step of the training procedure. This does not include
model size and optimizer parameters that are allocated outsize workspace. Hence
you cannot allocate all GPU memory to workspace. If you are not happy with
default values this is a trial and error process.

Setting `--mini-batch 64 --max-length 100` will generate batches that contain
always 64 sentences (or less if the corpus is smaller) of up to a length of 100
tokens. Sentences longer than that are filtered out. Marian will grow workspace
memory if required and potentially exceed available memory, resulting in a
crash. Workspace memory is always rounded to multiples of 512 MB.

`--mini-batch-fit` overrides the specified mini-batch size and automatically
choses the largest mini-batch for a given sentence length that fits the
specified memory. When `--mini-batch-fit` is set, memory requirements are
guaranteed to fit into the specified workspace. Choosing a too small workspace
will result in small mini-batches which can prohibit learning.

#### My rules of thumb

For shallow models I usually set the working memory to values between 3500 and
6000 (MB), e.g. `--workspace 5500` and then use `--mini-batch-fit` which
automatically tries to make the best use of the specified memory size,
mini-batch size and sentence length.

For very deep models, I first set all other parameters like `--max-length 100`,
model type, depth etc.  Next I use `--mini-batch-fit` and try to max out
`--workspace` until I get a crash due to insufficient memory. I then revert to
the last workspace size that did not crash. Since setting `--mini-batch-fit`
guarantees that memory will not grow during training due to batch-size this
should result in a stable training run and maximal batch size.


### Multi-node training

Multi-node training requires an MPI installation with `MPI_THREAD_MULTIPLE` set to
`true`. A newer version (e.g. OpenMPI 2.X) is highly recommended due to intense
use of multi-threading.

Command-line options specific to multi-node training:

- `--multi-node` - enable multi-node.
- `--devices` - set nodes and devices, e.g. `0: 0 1 1: 0` means that node 0 has
  2 GPUs, with IDs 0 and 1, and node 1 has 1 GPU, with ID 0.
- `--multi-node-overlap` - overlap communication with computations, default:
  enabled.

To start multi-node training, except compiling Marian with MPI, you need to
create a host file and ensure that the nodes can ssh to each other without a
password. Then you may use the command similar to:

    mpirun -n 2 --hostfile hosts_mpi -tag-output \
        ./build/marian --devices 0:0 1 1:0 \
            -m model.npz -t corpus.src corpus.trg -v vocab.src.yml vocab.trg.yml \
            --multi-node --multi-node-overlap 0

where the host file `hosts_mpi` contains on each line a host on which you want
to run Marian.

Note that multi-node currently only converges properly with gradient dropping,
which requires layer normalization. Ideally, add the following line to your run
script:

    --layer-normalization --dropout-rnn 0.2 --dropout-src 0.1 --dropout-trg 0.1

This is still an experimental feature introduced in version 1.4.0.


## Translation

All model types can be decoded with `marian-decoder` and `marian-server`
command.  Only models of type Amun and certain models of type Nematus can be
used with the `amun` tool.

### Marian decoder

Currently, `marian-decoder` supports only translation on GPUs. A CPU version
of Marian is planned.

Basic usage:

    ./build/marian-decoder -m model.npz -v vocab.en vocab.ro < input.txt

### Ensembles

Models of different types and architectures can be ensembled as long as they
use common vocabularies:

    ./build/marian-decoder \
        --models model1.npz model2.npz model3.npz \
        --weights 0.6 0.2 0.2 \
        --vocabs vocab.en vocab.ro < input.txt

Weights are optional and set to 1.0 by default if ommitted.

### Length normalization

We found that using length normalization with a penalty term of 0.6 and a beam
size of 6 is usually best:

    ./marian-decoder -m model.npz -v vocab.src.yml vocab.trg.yml -b 6 --normalize=0.6

This rougly follows the settings by Google from their [transformer
paper](https://arxiv.org/abs/1706.03762).

### Batched translation

This is a feature introduced in Marian v1.1.0. Batched translation generates
translation for whole mini-batches and significantly increases translation
speed (roughly by a factor of 10 or more). We recommend to use the following
options to enable batched translation:

    ./marian-decoder -m model.npz -v vocab.src.yml vocab.trg.yml -b 6 --normalize=0.6 \
        --mini-batch 64 --maxi-batch-sort src --maxi-batch 100 -w 2500

This does a number of things:
- Firstly, it enables translation with a mini-batch size of 64, i.e.
  translating 64 sentences at once, with a beam-size of 6.
- It preloads 100 maxi-batches and sorts them according to source sentence
  length, this allows for better packing of the batch and increases translation
  speed quite a bit.
- We also added an option to use a length-normalization weight of 0.6 (this
  usually increases BLEU a bit).
- The working memory is set to 2500 MB. The default working memory is 512 MB
  and Marian will increase it to match to requirements during translation, but
  pre-allocating memory makes it usually a bit faster.

To give you an idea, how much faster batched translation is compared to
sentence-by-sentence translation we have collected a few numbers. Below we have
compiled the time it takes to translate the English-German WMT2013 test set
with 3000 sentences using 4 Volta GPUs on AWS.

System | Single | Batched |
-------|-------:|--------:|
Nematus-style Shallow RNN | 82.7s | 4.3s |
Nematus-style Deep RNN | 148.5s | 5.9s |
Google Transformer | 201.9s | 19.2s |
{: .table .table-bordered .table-striped }

### Nematus models

Certain types of models trained with Nematus, for example the [Edinburgh WMT17
deep models](http://data.statmt.org/wmt17_systems/) can be decoded with
`marian-decoder`.  As such models do not include model parameters specifying
the model architecture, all parameters have to be set through command-line
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

A cross-entropy score for each sentence pair is returned by default.

### N-best lists

The scorer does not support n-best lists as an input yet.

If you want to use the rescorer for for n-best list rescoring you need to
extract the sentences to a plain text file. If the model is a translation model
you also need to create a source file that has the correct source sentences in
the right order and number, i.e. you need to repeat the source sentence as many
times as there are entries in the corresponding n-best list.

### Summarized scores

The scorer can be also used to summarize scores (option `--summary`). It can
calculate cross-entropy and perplexity for a whole test set and report it at
the end.



## Code documentation

[The code documentation for Marian toolkit](/docs/marian/classes.html) is
generated using Doxygen. The newest version can be generated locally with CMake:

    mkdir -p build && cd build && cmake .. && make doc
