---
layout: docs
title: Quick start
permalink: /quickstart/
icon: fa-paper-plane
menu: 1
---

## Recommended software

### GPU version

Ubuntu 16.04 LTS (tested and recommended)

 * CMake 3.5.1 (due to CUDA related bugs in earlier versions)
 * GCC/G++ 5.4
 * Boost 1.61
 * CUDA 8.0

Also compiles the CPU version.

Ubuntu 14.04 LTS (tested)

 * CMake 3.5.1 (due to CUDA related bugs in earlier versions)
 * GCC/G++ 4.9
 * Boost 1.54
 * CUDA 7.5

### CPU version

The CPU-only version will automatically be compiled if CUDA cannot be detected by CMAKE. Tested on different machines and distributions:

 * CMake 3.5.1
 * The CPU version should be a lot more forgiving concerning GCC/G++ or Boost versions.

## Compilation

The project is a standard CMake out-of-source build:

    mkdir build
    cd build
    cmake ..
    make -j

If run for the first time, this will also download Marian -- the training
framework for AmuNMT.

## Running AmuNMT

### Training

Marian is the training framework of AmuNMT. Assuming `corpus.en` and `corpus.ro` are
corresponding and preprocessed files of a English-Romanian parallel corpus, the
following command will create a Nematus-compatible neural machine translation model.

    ./amunmt/build/marian \
      --train-sets corpus.en corpus.ro \
      --vocabs vocab.en vocab.ro \
      --model model.npz

See the [documentation](/docs/#marian) for a full list of command line
options or the [examples](/usecases/training) for a full example of how to train
a WMT-grade model.

### Translating

If a trained model is available

    ./amunmt/build/amun -m model.npz -s vocab.en -t vocab.ro <<< "This is a test ."

See the [documentation](/docs/#amun) for a full list of command line options
or the [examples](/usecases/translating) for a full example of how to use
Edinburgh's WMT models for translation.
