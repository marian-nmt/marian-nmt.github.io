---
layout: docs
title: Documentation
permalink: /docs/
icon: fa-file-code-o
menu: 3
latex: true
---

## Overview

Version:
v1.9.1 95c65bb 2020-03-17 03:30:49 +0000

Marian toolkit provides the following tools:

- [marian](/docs/cmd/marian): training NMT models and language models.
- [marian-decoder](/docs/cmd/marian-decoder): CPU and GPU translation using NMT
  models trained with Marian.
- [marian-server](/docs/cmd/marian-server): a web-socket server providing
  translation service.
- [marian-scorer](/docs/cmd/marian-scorer): rescoring parallel text files and
  n-best lists.
- [marian-vocab](/docs/cmd/marian-vocab): creating a vocabulary from text given
  on STDIN.
- [marian-conv](/docs/cmd/marian-vocab): converting a model into a binary
  format.

The [amun](/docs/cmd/amun) tool offering CPU and GPU translation with specific
Marian and Nematus models, which used to be a part of Marian, has been moved to
its separate repository and is available from:
[https://github.com/marian-nmt/amun](https://github.com/marian-nmt/amun)



### Command-line options

Click on the tool name above for a list of command line options. See options
for [previous releases](/docs/cmd).



### Model types

- `s2s`: An RNN-based encoder-decoder model with attention mechanism. The
  architecture is equivalent to the
  [DL4MT](https://github.com/nyu-dl/dl4mt-tutorial) or
  [Nematus](https://github.com/EdinburghNLP/nematus) models ([Senrich et al.,
  2017](https://arxiv.org/abs/1703.04357)).
- `transformer`: A model originally proposed by Google [(Vaswani et al.,
  2017)](https://arxiv.org/abs/1706.03762) based solely on attention mechanisms.
- `multi-s2s`: As `s2s`, but uses two or more encoders allowing multi-source
  neural machine translation.
- `multi-transformer`: As `transformer`, but uses multiple encoders.
- `amun`: A model equivalent to Nematus models unless layer normalization is
  used. Can be decoded with Amun as _nematus_ model type.
- `nematus`: A model type developed for decoding deep RNN-based encoder-decoder
  models created by the Edinburgh MT group for WMT 2017 using Nematus toolkit.
  Can be decoded with Amun as _nematus2_ model type.
- `lm`: An RNN language model.
- `lm-transformer`: An transformer-based language model.



## Installation

Clone a fresh copy from github:

    git clone https://github.com/marian-nmt/marian

The project is a standard CMake out-of-source build:

    mkdir marian/build
    cd marian/build
    cmake ..
    make -j4

The complete list of compilation options in the form of CMake flags can be
obtained by running `cmake -LH -N` or `cmake -LAH -N` from the `build`
directory after running `cmake ..` first.



### Ubuntu packages

Assuming a fresh Ubuntu LTS installation with CUDA, the following packages need
to be installed to compile with all features, including the web server,
built-in SentencePiece and TCMalloc support.

* Ubuntu 18.04 + CUDA 9.2 (defaults are gcc 7.3.0, Boost 1.65):

      sudo apt-get install git cmake build-essential libboost-all-dev libprotobuf10 protobuf-compiler libprotobuf-dev openssl libssl-dev libgoogle-perftools-dev

* Ubuntu 16.04 + CUDA 9.2 (gcc 5.4.0, Boost 1.58):

      sudo apt-get install git cmake build-essential libboost-all-dev zlib1g-dev libprotobuf9v5 protobuf-compiler libprotobuf-dev openssl libssl-dev libgoogle-perftools-dev

* Ubuntu 14.04: gcc 4.8.4 and CUDA 8.0 that are available from the default
  package repositories are no longer supported, so first install gcc-5, g++-5
  and CUDA 9.0 or higher, then:

      sudo apt-get install git cmake3 build-essential libboost-all-dev libprotobuf8 protobuf-compiler libprotobuf-dev openssl libssl-dev libgoogle-perftools-dev

Please see the [GCC/CUDA compatibility
table](https://github.com/marian-nmt/marian-dev/issues/526) if you experience
compilation issues with different versions of GCC and CUDA.


### Static compilation

Marian will be compiled statically if the flag `USE_STATIC_LIBS` is set:

    cd build
    cmake .. -DUSE_STATIC_LIBS=on
    make -j4



### Custom Boost

Download, compile and install Boost:

    wget https://dl.bintray.com/boostorg/release/1.67.0/source/boost_1_67_0.tar.gz
    tar zxvf boost_1_67_0.tar.gz
    cd boost_1_67_0
    ./bootstrap.sh
    ./b2 -j16 --prefix=$(pwd) --libdir=$(pwd)/lib64 --layout=system link=static install

If Boost can not be compiled on your machine because an error like this occurs:
_boost error "none" is not a known value of feature <optimization\>_, you may
try adding `--ignore-site-config` to the `./b2` command.

To compile Marian training framework with your custom Boost installation:

    cd /path/to/marian-dev
    mkdir build
    cd build
    cmake .. -DBOOST_ROOT=/path/to/boost_1_67_0
    make -j4

Tested on Ubuntu 16.04.3 LTS.

Since 1.9.0, Boost is only required if you compile the web server tool
supplying `-DCOMPILE_SERVER=on` to the CMake command.



### Non-default CUDA

Specify the path to your CUDA root directory via CMake:

    cd /path/to/marian-dev
    mkdir build
    cd build
    cmake .. -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-9.1
    make -j4



### CPU version

Marian CPU version requires [Intel MKL](https://software.intel.com/en-us/mkl) or
[OpenBLAS](https://www.openblas.net/). Both are free, but MKL is not
open-sourced. Intel MKL is strongly recommended as it is faster. On Ubuntu
16.04 it can be installed using the following steps:

```
wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB
sudo apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB
sudo sh -c 'echo deb https://apt.repos.intel.com/mkl all main > /etc/apt/sources.list.d/intel-mkl.list'
sudo apt-get update
sudo apt-get install intel-mkl-64bit-2019.4-XYZ
```

Where _XYZ_ is the revision number.

A CPU build can be enabled by adding `-DCOMPILE_CPU=on` to the CMake command.



### SentencePiece

Compilation with SentencePiece that is built-it in Marian v1.6.2+ can be
enabled by adding `-DUSE_SENTENCEPIECE=on` to the CMake command and requires
the Protobuf library.  On Ubuntu, you would need to install a couple of
packages:

    # Ubuntu 14.04 LTS (Trusty Tahr):
    sudo apt-get install libprotobuf8 protobuf-compiler libprotobuf-dev

    # Ubuntu 16.04 LTS (Xenial Xerus):
    sudo apt-get install libprotobuf9v5 protobuf-compiler libprotobuf-dev

    # Ubuntu 17.10 (Artful Aardvark) and Later:
    sudo apt-get install libprotobuf10 protobuf-compiler libprotobuf-dev

You may also compile Protobuf from source. For Ubuntu 16.04 LTS, version 2.6.1
(or possibly newer) works:

    wget https://github.com/protocolbuffers/protobuf/releases/download/v2.6.1/protobuf-cpp-2.6.1.zip
    unzip protobuf-cpp-2.6.1.zip
    cd protobuf-2.6.1
    ./autogen.sh
    ./configure --prefix $(pwd)
    make -j4
    make install

and set the following CMake flags in Marian compilation:

    mkdir build
    cd build
    cmake .. -DUSE_SENTENCEPIECE=on \
        -DPROTOBUF_LIBRARY=/path/to/protobuf-2.6.1/lib/libprotobuf.so \
        -DPROTOBUF_INCLUDE_DIR=/path/to/protobuf-2.6.1/include \
        -DPROTOBUF_PROTOC_EXECUTABLE=/path/to/protobuf-2.6.1/bin/protoc

For more details see the documentation in the SentencePiece repo:
https://github.com/marian-nmt/sentencepiece#c-from-source



## Training

For training NMT models, you want to use `marian` command.  Assuming `corpus.en`
and `corpus.ro` are corresponding and preprocessed files of a English-Romanian
parallel corpus, the following command will create a Nematus-compatible neural
machine translation model:

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

For multi-GPU training you only need to specify the device ids of the GPUs you
want to use for training (this also works with most other binaries) as
`--devices 0 1 2 3` for training on four GPUs. There is no automatic detection
of GPUs for now.

By default, this will use asynchronous SGD (or rather ADAM). For the deeper
models and the transformer model, we found async SGD to be unreliable and you
may want to use a synchronous SGD variant by setting `--sync-sgd`.

For asynchronous SGD, the mini-batch size is used locally, i.e. `--mini-batch
64` means 64 sentences per GPU worker.

For synchronous SGD, the mini-batch size is used globally and will be divided
across the number of workers. This means that for synchronous SGD the effective
mini-batch can be set N times larger for N GPUs. A mini-batch size of
`--mini-batch 256` will mean a mini-batch of 64 per worker if four GPUs are
used. This choice makes sense when you realize that synchronous SGD is
essentially working like a single GPU training process with N times more memory.
Larger mini-batches in a synchronous setting result in quite stable training.



### Workspace memory

The choice of workspace memory, mini-batch size and max-length is quite involved
and depends on the type of model, the available GPU memory, the number of GPUs,
a number of other parameters like the chosen optimization algorithm, and the
average or maximum sentence length in your training corpus (which you should
know!).

The option `--workspace` sets the size of the memory available for the forward
and backward step of the training procedure. This does not include model size
and optimizer parameters that are allocated outsize workspace. Hence you cannot
allocate all GPU memory to workspace. If you are not happy with default values
this is a trial and error process.

Setting `--mini-batch 64 --max-length 100` will generate batches that contain
always 64 sentences (or less if the corpus is smaller) of up to a length of 100
tokens. Sentences longer than that are filtered out. Marian will grow workspace
memory if required and potentially exceed available memory, resulting in a
crash. Workspace memory is always rounded to multiples of 512 MB.

`--mini-batch-fit` overrides the specified mini-batch size and automatically
chooses the largest mini-batch for a given sentence length that fits the
specified memory. When `--mini-batch-fit` is set, memory requirements are
guaranteed to fit into the specified workspace. Choosing a too small workspace
will result in small mini-batches which can prohibit learning.

#### My rules of thumb

For shallow models I usually set the working memory to values between 3500 and
6000 (MB), e.g.  `--workspace 5500` and then use `--mini-batch-fit` which
automatically tries to make the best use of the specified memory size,
mini-batch size and sentence length.

For very deep models, I first set all other parameters like `--max-length 100`,
model type, depth etc.  Next I use `--mini-batch-fit` and try to max out
`--workspace` until I get a crash due to insufficient memory. I then revert to
the last workspace size that did not crash. Since setting `--mini-batch-fit`
guarantees that memory will not grow during training due to batch-size this
should result in a stable training run and maximal batch size.



### Validation

It is useful to monitor the performance of your model during training on
held-out data. Just provide `--valid valid.src valid.trg` for that. By default
this provide sentence-wise normalized cross-entropy scores for the validation
set every 10,000 iterations.  You can change the validation frequency to, say
5000, with `--valid-freq 5000` and the display frequency to 500 with
`--disp-freq 500`.

**Attention:** the validation set needs to have been preprocessed in exactly the
same manner as your training data.

A minimum example of how to validate the model using cross-entropy and BLEU
score:

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

#### Metrics

- `cross-entropy` - computes the sentence-wise normalized cross-entropy score.
- `ce-mean-words` - computes the mean word cross-entropy score.
- `valid-script` - executes the script specified with `--valid-script-path`.
  The script is expected to return a score as a floating-point number.
- `translation` - executes the script specified with `--valid-script-path`
  passing the name of the file with translation of the source validation set as
  the first argument (e.g. `$1` in Bash script, `sys.argv[1]` in Python, etc.).
  The script is expected to return a score as a floating-point number.
- `bleu` - computes BLEU score on raw validation sets. Those are usually
  tokenized and BPE-segmented, so the score is overestimated, and should never
  be used to report your BLEU scores in a research paper.
- `bleu-detok` - computes BLEU score on postprocessed validation sets. Requires
  SentencePiece and Marian v1.6.2+.

#### Early stopping

Early stopping is a common technique for deciding when to stop training the
model based on a heuristic involving a validation set.

By default we use early stopping with patience of 10, i.e. `--early-stopping
10`. This means that training will finish if the first specified metric in
`--valid-metrics` did not improve (stalled) for 10 consecutive validation
steps. Usually this will signal convergence or --- if the scores get worse with
later validation steps --- potential overfitting.



### Regularization

Marian has several regularization techniques implemented that help to prevent
model overfitting, such as dropouts ([Gal and Ghahramani,
2016](https://arxiv.org/abs/1512.05287)), label smoothing ([Vaswani et al.
2017](https://arxiv.org/abs/1706.03762)), and [exponential
smoothing](https://en.wikipedia.org/wiki/Exponential_smoothing) for network
parameters.

#### Dropouts

Depending on the model type, Marian support multiple types of dropout.  For
RNN-based models it supports the `--dropout-rnn 0.2` (the numeric value of 0.2
is only provided as an example) option which uses variational dropout on all
RNN inputs and recursive states.

Options `--dropout-src` and `--dropout-trg` set the probability to drop out
entire source or target word positions, respectively. These dropouts are useful
for monolingual tasks.

For the transformer model the equivalent of `--dropout-rnn 0.2` is
`--transformer-dropout 0.2`. There are also two other dropouts for transformer
attention and transformer filter.



### Learning rate scheduling

Manipulation of learning rate during the training may result in better
convergence and higher-quality translations.

Marian supports various strategies for decaying learning rate
(`--lr-decay-strategy` option).  Decay factor can be specified with
`--lr-decay`.

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

Other learning rate schedules supported by Marian:

- `--lr-warmup`: learning rate will be increased linearly for the specific
  number of first updates. The start value for learning rate warmup can be
  specified with `--lr-warmup-start-rate`.
- `--lr-decay-inv-sqrt`: learning rate will be decreased at `n / sqrt(no.
  updates)` starting at `n`-th update



### Data weighting

Data weighting is commonly used as a domain adaptation technique, which weights
each data item according to its proximity to the in-domain data.  Marian
supports sentence and word-level data weighting strategies.

Data weighting requires providing a file with weights.  In sentence weighting
strategy, each line of that file contains a real-value weight:

    ./build/marian \
        -t corpus.{en,de} -v vocab.{en,de} -m model.npz \
        --data-weighting-type sentence --data-weighting weights.txt

To use word weighting you should choose `--data-weighting-type word`, and each
line of the weight file should contain as many real-value weights as there are
words in the corresponding target training sentence.



### Custom embeddings

Marian can handle custom embedding vectors trained with
[word2vec](https://github.com/dav/word2vec) or another tool:

    ./build/marian \
        -t corpus.{en,de} -v vocab.{en,de} -m model.npz \
        --embedding-vectors vectors.{en,de} --dim-emb 400

Embedding vectors should be provided in a file in a format similar to the
word2vec format, with word tokens replaced with words IDs from the relevant
vocabulary.

Pre-trained vectors need to share the same vocabulary as your training data,
and ideally should contain vectors for `<unk>` and `</s>` tokens. The easiest
way to achieve this is to prepare the training data for word2vec w.r.t your
vocabularies using {% github_link
marian-dev/scripts/embeddings/prepare_corpus.py %}. Vectors can be prepared or
trained w.r.t to vocabulary using {% github_link
marian-dev/scripts/embeddings/process_word2vec.py %}.

Other options for managing embedding vectors:

- `--embedding-fix-src` fixes source embeddings in all encoders
- `--embedding-fix-trg` fixes target embeddings in all decoders
- `--embedding-normalization` normalizes vector values into [-1,1] range



### Guided alignment

Training with guided alignment may improve alignments produced by RNN models
(`--type amun` or `s2s`) and is mandatory to obtain useful word alignments from
Transformers (`--type transformer`).  Guided alignment training requires
providing a file with pre-calculated word alignments for the entire training
corpus, for example:

    ./build/marian \
        -t corpus.{en,de} -v vocab.{en,de} -m model.npz \
        --guided-alignment corpus.align

The file _corpus.align_ from the example can be generated using the
[fast_align](https://github.com/clab/fast_align) word aligner (please refer to
their repository for installation instructions):

    paste corpus.en corpus.de | sed 's/\t/ ||| /g' > corpus.en-de
    fast_align/build/fast_align -vdo -i corpus.en-de > forward.align
    fast_align/build/fast_align -vdor -i corpus.en-de > reverse.align
    fast_align/build/atools -c grow-diag-final -i forward.align -j reverse.align > corpus.align

or a RNN model and `marian-scorer`, for example:

    ./build/marian-scorer -m model.npz -v vocab.{en,de} -t corpus.en corpus.de > corpus.align

Marian has a few more options related to guided alignment training:

- `--guided-alignment-cost` - cost type for guided alignment
- `--guided-alignment-weight` - weight for guided alignment cost
- `--transformer-guided-alignment-layer` - number of layer to use for guided
  alignment training; only for training transformer models



## Translation

All models trained with `marian` can be decoded with `marian-decoder` and
`marian-server` command.  Only models of type `amun` and specific deep models of type
`nematus` can be used with the `amun` tool.



### Marian decoder

Currently, `marian-decoder` supports only translation on GPUs. A CPU version
of Marian is planned.

Basic usage:

    ./build/marian-decoder -m model.npz -v vocab.en vocab.ro < input.txt

#### N-best lists

To generate n-best list with, say 10, best translations for each input
sentence, add `--n-best` and `--beam-size `10` to the list of command-line
arguments:

    ./build/marian-decoder -m model.npz -v vocab.en vocab.ro --beam-size 10 --n-best < input.txt

#### Ensembles

Models of **different** types and architectures can be ensembled as long as they
use common vocabularies:

    ./build/marian-decoder \
        --models model1.npz model2.npz model3.npz \
        --weights 0.6 0.2 0.2 \
        --vocabs vocab.en vocab.ro < input.txt

Weights are optional and set to 1.0 by default if omitted.



### Batched translation

Batched translation generates translation for whole mini-batches and
significantly increases translation speed (roughly by a factor of 10 or more).
We recommend to use the following options to enable batched translation:

    ./marian-decoder -m model.npz -v vocab.src.yml vocab.trg.yml -b 6 --normalize 0.6 \
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



### Attention output

`marian-decoder` and `marian-scorer` can produce attention output or word
alignments when the `--alignment` option is used with one of the following
values:

- `soft`: Alignment weights for all words including EOS tokens. Sets of source
  token weights for target tokens are separated by a whitespace, source token
  weights are separated by a comma.
```
echo "now everyone knows" | ./marian-decoder -c config.yml --alignment soft
jetzt weiß jeder ||| 0.917065,0.0218936,0.0405725,0.0204688 0.00803049,0.0954254,0.853882,0.0426626 \
    0.0294334,0.794184,0.00511072,0.171272 0.00743875,0.0147502,0.201069,0.776743
```

- `hard` or empty: Word alignments for each target token in the form of Moses
  alignments, i.e. pairs of source and target tokens.
```
echo "now everyone knows" | ./marian-decoder -c config.yml --alignment
jetzt weiß jeder ||| 0-0 1-2 2-1 3-3
```

- A value in the range 0.0-1.0: Word alignments are generated if the alignment
  weight for a target and source token is higher than or equal to the specified
  value.
```
echo "now everyone knows" | ./marian-decoder -c config.yml --alignment 0.1
jetzt weiß jeder ||| 0-0 1-2 2-1 2-3 3-2 3-3
```


#### Word alignments from Transformer

The transformer has basically 6x8 different alignment matrices, and in theory
none of these has to be very useful for word alignment purposes.  We recommend
training model with guided alignments first (`--guided-alignment`) so that the
model can learn word alignments in one of its heads.



### Lexical shortlists

With a lexical shortlist the output vocabulary is restricted to a small subset
of translation candidates, which can improve CPU-bound efficiency. A shortlist
file, say _lex.s2t_, can be passed to the decoder using the `--shortlist`
option, for example:

    ./build/marian-decoder -m model.npz -v vocab.en vocab.de \
        --shortlist lex.s2t 100 75 < input.txt

The second and third arguments are optional, and mean that the output
vocabulary will be restricted to the 100 most frequent target words and the 75
most probable translations for every source word in a batch.

Lexical shortlist files can be generated with {% github_link
marian-dev/scripts/shortlist/generate_shortlists.pl %}, for example:

    perl generate_shortlists.pl --bindir /path/to/bin -s corpus.en -t corpus.de

where _corpus.en_ and _corpus.de_ are preprocessed training data, and the `bin`
directory contains `fast_align` and `atools` from
[fast_align](https://github.com/clab/fast_align) and `extract_lex` from
[extract-lex](https://github.com/marian-nmt/extract-lex).



### Web server

The `marian-server` command starts a web-socket server providing CPU and GPU
translation service that can be requested by a client program written in Python
or any other programming language.  The server uses the same command-line
options as `marian-decoder`.  The only addition is `--port` option, which
specifies the port number:

    ./build/marian-server --port 8080 -m model.npz -v vocab.en vocab.ro

An example client written in Python is {% github_link
marian-dev/scripts/server/client_example.py %}:

    ./scripts/server/client_example.py -p 8080 < input.txt



### Nematus models

Only specific types of models trained with Nematus, for example the [Edinburgh WMT17
deep models](http://data.statmt.org/wmt17_systems/) can be decoded with
`marian-decoder`.  As such models do not include Marian-specific parameters,
all parameters related to the model architecture have to be set with
command-line options.

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

Alternatively, the parameters can be added into the model _.npz_ file based on
the Nematus _.json_ file using the script: {% github_link
marian-dev/scripts/contrib/inject_model_params.py %}, e.g.:

    python inject_model_params.py -m model.npz -j model.npz.json

Some models released by Edinburgh might require setting other parameters as
well, for instance `--dim-emb 500`.

We do not recommend training models of type `nematus` with Marian. It is much
more efficient to train `s2s` models, which provide the same model architecture
(except layer normalization), more features, and faster training.



## Scorer

The `marian-scorer` tool is used for scoring (or re-scoring) parallel sentences
provided as plain texts in two corresponding files:

    ./build/marian-scorer -m model.npz -v vocab.{en,de} -t file.en file.de

A cross-entropy score for each sentence pair is returned by default.



### Scoring n-best lists

N-best lists can be scored using the following command:

    ./build/marian-scorer -m model.npz -v vocab.{en,de} \
        -t file.en.txt file.de.nbest --n-best --n-best-feature F0

which add a new score into the n-best list under the feature named _F0_.



### Word aligner

The scorer can be used as a word aligner that generates word alignments for a
pair of sentences:

    ./build/marian-scorer -m model.npz -v vocab.{en,de} \
        -t file.en.txt file.de.txt --alignment

The feature works out-of-the-box for RNN models, while Transformer models need
to be trained with guided alignments.



### Summarized scores

The scorer can report summarized score (cross-entropy or perplexity) for an
entire test set with option `--summary`.



## Code documentation

[The code documentation for Marian toolkit](/docs/marian/classes.html) is
generated using Doxygen. The newest version can be generated locally with CMake:

    mkdir -p build && cd build && cmake .. && make doc
