---
layout: docs
title: MTM2018 Labs - Part 1
permalink: /examples/mtm2018/part1
icon: fa-cogs
---

## Environment setup

1. AWS EC2: follow the official MTM 2018 instructions on how to use your
   voucher and start an instance of an AWS virtual machine, then follow
   installation instructions below or use the [prepared docker files]().
2. Student machines at MTM: on machines equipped with GPUs (_u-pl21_ to
   _u-pl37_), you need to compile Marian with [a newer
   Boost](/docs/#custom-boost) and disable CPU back-end by adding
   `-DUSE_CPU=off` to CMake flags.
3. Private laptop or server: on machines with a UNIX system, CUDA and Boost
   installed, just follow installation instructions below. Add
   `-DCOMPILE_CUDA=off` on CPU-only machines with OpenBLAS or MKL installed.


## About Marian

**Marian** is an efficient Neural Machine Translation framework written in pure
C++ with minimal dependencies. It has mainly been developed at the Adam
Mickiewicz University in Poznań (AMU) and at the University of Edinburgh.
It is currently being deployed in multiple European and commercial projects.

Marian is also a Machine Translation Marathon 2016 project that is celebrating
its second birthday during the current MTM!

More information:
- [Features & benchmarks](/features)
- [Documentation](/docs)
- [FAQ](/faq)
- [Google discussion group](https://groups.google.com/forum/#!forum/marian-nmt)
- [GitHub issues](http://github.com/marian-nmt/marian-dev/issues)

## Installation

There are two repositories that marian can be obtained from:
`marian-nmt/marian` and `marian-nmt/marian-dev`.  The former includes the
latest stable release of Marian and Amun --- a fast C++ decoder for shallow
RNN-based encoder-decoder models and a predestor of Marian.  The latter is our
main development repository.

As Amun adds extra requirements, we suggest using `marian-dev` for this
tutorial.

### Requirements

Marian can be compiled on machines with NVIDIA GPU devices and CUDA 8.0+ or on
CPU-only machines.  The CPU version of Marian is compiled automatically if
OpenBLAS or Intel MKL (suggested) are found.  Compilation either of GPU or CPU
back-end can be disabled (details below).

Currently the main dependency of Marian is Boost, which should be already
installed on your machine.

### Checkout and compilation

To download the repository and compile Marian, run the following commands:

```
git clone https://github.com/marian-nmt/marian-dev
cd marian-dev
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j
```

If everything worked correctly you can display the list of options with:

```
./marian --help |& less
```

You should have at least these tools ready to use:

- `marian` - a tool for training NMT and LM models
- `marian-decoder` - a translation tool
- `marian-scorer` - a tool for scoring parallel texts and n-best lists

### Troubleshooting

- Compilation on a CPU-only machine: add flag `-DCOMPILE_CUDA=off` to the `cmake` command.
- Skipping compilation of CPU backend: add flag `-DUSE_CPU=off` to the `cmake` command.
- Boost issues: see [instructions how to compile with custom Boost](/docs/#custom-boost).
- Other resources you may refer to: [documentation](/docs) and [FAQ](/faq).


## Tools and data

We will also need to download a couple of useful scripts for preprocessing,
splitting into subwords, getting test sets.

Return to the working directory and download the scripts:

```
cd ../..

git clone https://github.com/marian-nmt/moses-scripts
git clone https://github.com/rsennrich/subword-nmt
git clone https://github.com/mjpost/sacreBLEU -b master
```

- - - -

Continue with **[Part 2: Basics](/examples/mtm2018/part2/)**

Continue with **[Part 3: Exercises](/examples/mtm2018/part3/)**
