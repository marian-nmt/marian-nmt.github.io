---
layout: docs
title: Quick start
permalink: /quickstart/
icon: fa-paper-plane
menu: 1
---

## Recommended software

### GPU version

**Ubuntu 16.04 LTS (tested and recommended).**
For Ubuntu 16.04 the standard packages should work. On newer versions of
Ubuntu, e.g. 16.10, there may be problems due to incompatibilities of the
default g++ compiler and CUDA.

 * CMake 3.5.1
 * GCC/G++ 5.4
 * Boost 1.58
 * CUDA 8.0

**Ubuntu 14.04 LTS (tested).**
A newer CMake version than the default version is required and can be installed
from source.

 * CMake 3.5.1 (due to CUDA related bugs in earlier versions)
 * GCC/G++ 4.9
 * Boost 1.54
 * CUDA 7.5

### CPU version

The CPU-only version will automatically be compiled if CUDA cannot be detected by CMake.
Only the translator will be compiled, the training framework is strictily GPU-based.

Tested on different machines and distributions:

 * CMake 3.5.1
 * The CPU version should be a lot more forgiving concerning GCC/G++ or Boost versions.

## Download and Compilation

Clone a fresh copy from github:

    git clone https://github.com/marian-nmt/marian

The project is a standard CMake out-of-source build:

    cd marian
    mkdir build
    cd build
    cmake ..
    make -j

If run for the first time, this will also download Marian -- the training
framework for Marian.

## Running Marian

### Training

Marian is the training framework of Marian. Assuming `corpus.en` and `corpus.ro` are
corresponding and preprocessed files of a English-Romanian parallel corpus, the
following command will create a Nematus-compatible neural machine translation model.

    ./marian/build/marian \
      --train-sets corpus.en corpus.ro \
      --vocabs vocab.en vocab.ro \
      --model model.npz

See the [documentation](/docs/#marian) for a full list of command line
options or the [examples](/examples/training) for a full example of how to train
a WMT-grade model.

### Translating

If a trained model is available, run:

    ./marian/build/amun -m model.npz -s vocab.en -t vocab.ro <<< "This is a test ."

See the [documentation](/docs/#amun) for a full list of command line options
or the [examples](/examples/translating) for a full example of how to use
Edinburgh's WMT models for translation.
