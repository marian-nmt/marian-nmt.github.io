---
layout: docs
title: Quick start
permalink: /quickstart/
icon: fa-paper-plane
menu: 1
---

## Recommended software

### GPU version

For Ubuntu 16.04/18.04 LTS the standard packages should work. On newer versions
of Ubuntu, there may be problems due to incompatibilities of the default g++
compiler and CUDA. Minimal requirements:

 - CMake 3.5.1
 - GCC/G++ 5.4
 - Boost 1.65.1
 - CUDA 9.0 or newer

Notes:

* CUDA 10.0+ requires CMake 3.12.2+ due to some bugs in earlier versions


### CPU version

A Marian CPU build requires [Intel MKL](https://software.intel.com/en-us/mkl)
(recommended) or [OpenBLAS](https://www.openblas.net/).
It can be enabled by adding `-DCOMPILE_CPU=on` to the CMake command.


### Ubuntu packages

Assuming a fresh Ubuntu LTS installation with CUDA, the following packages need to be
installed to compile Marian with minimal dependencies:

* Ubuntu 18.04 + CUDA 9.2 (defaults are gcc 7.3.0, Boost 1.65):

      sudo apt-get install git cmake build-essential libboost-all-dev

* Ubuntu 16.04 + CUDA 9.2 (gcc 5.4.0, Boost 1.58):

      sudo apt-get install git cmake build-essential libboost-all-dev zlib1g-dev


Additional [packages](/docs/#ubuntu-packages) can be installed to compile
Marian with the web server, built-in SentencePiece and TCMalloc support.


## Installation

Clone a fresh copy from github:

    git clone https://github.com/marian-nmt/marian

The project is a standard CMake out-of-source build:

    cd marian
    mkdir build
    cd build
    cmake ..
    make -j

If run for the first time, this will also download several submodule repositories.


## Running Marian

### Training

Marian is the training framework of Marian. Assuming `corpus.en` and
`corpus.ro` are corresponding and preprocessed files of a English-Romanian
parallel corpus, the following command will create a Nematus-compatible neural
machine translation model.

    ./marian/build/marian \
      --train-sets corpus.en corpus.ro \
      --vocabs vocab.en vocab.ro \
      --model model.npz

See the [documentation](/docs/#training) for more details or the
[examples](/examples/#examples) of how to train different models with Marian.

### Translation

If a trained model is available, run:

    ./marian/build/marian-decoder -m model.npz -v vocab.en vocab.ro <<< "This is a test ."

For faster CPU translation using shallow RNN models, use Amun:

    ./marian/build/amun -m model.npz -s vocab.en -t vocab.ro <<< "This is a test ."

See the [documentation](/docs/#translation) for more details or the
[examples](/examples/#examples) of how to use Edinburgh's WMT models for
translation.


## Resources

- [User Documentation](/docs) and [FAQ](/faq)
- [Google Discussion Group](https://groups.google.com/forum/#!forum/marian-nmt)
- Issues on GitHub repositories: [marian](https://github.com/marian-nmt/marian)
  and [marian-dev](https://github.com/marian-nmt/marian-dev)

