---
layout: docs
title: MTM2018 Labs - Part 1
permalink: /examples/mtm2018/part1
icon: fa-cogs
---

## About the tutorial

The tutorial should work with Marian version 1.2+

<!--### Setting up your machine-->

<!--- AWS EC2-->
<!--- Machines in labs-->
<!--- Private laptop/server-->


## About Marian

**Marian** is an efficient Neural Machine Translation framework written in pure
C++ with minimal dependencies. It has mainly been developed at the Adam
Mickiewicz University in Poznań (AMU) and at the University of Edinburgh.
It is currently being deployed in multiple European and commercial projects.

Marian is also a Machine Translation Marathon 2016 project that is celebrating
its second birthday during the current MTM!


## Installation

There are two repositories that marian can be obtained from: `marian-nmt/marian`
and `marian-nmt/marian-dev`.  The former includes Amun --- a fast C++ decoder for
shallow RNN-based encoder-decoder models and a predestor of Marian --- and the
latest stable release of Marian.  The latter is our main development
repository.

As Amun adds extra requirements, we suggest using `marian-dev` for the purpose
of this tutorial.

### Requirements

Marian can be compiled on machines with NVIDIA GPU devices and CUDA 8.0+ or on
CPU-only machines.  The CPU version of Marian is compiled automatically if
OpenBLAS or Intel MKL (suggested).  Compilation either of GPU or CPU back-end
can be disabled (details below).

Currently the main dependency of Marian is Boost.

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

For more help please refer to our [documentation](/docs) and [FAQ](/faq).


## Tools and data

We will also need to download a couple of useful scripts for preprocessing,
splitting into subwords, getting test sets and prepared examples.

Return to the working directory and download the scripts:

```
cd ../..

git clone https://github.com/marian-nmt/moses-scripts
git clone https://github.com/rsennrich/subword-nmt
git clone https://github.com/mjpost/sacreBLEU -b master

git clone https://github.com/marian-nmt/marian-examples
```

- - - -

Continue with **[Part 2: Basics](/examples/mtm2018/part2/)**

Continue with **[Part 3: Exercises](/examples/mtm2018/part3/)**
