---
layout: docs
title: Features & Benchmarks
permalink: /features/
icon: fa-bar-chart-o
menu: 2
---

## Features

### Overview
* Up to 15x faster translation than Nematus and similar toolkits on a single GPU
* Up to 2x faster training than toolkits based on Theano, Tensorflow, Torch on
  a single GPU
* Binary/model-compatible with
  [DL4MT](https://github.com/nyu-dl/dl4mt-tutorial) and
  [Nematus](https://github.com/rsennrich/nematus) models
* Multi-GPU training and translation
* Batched translation on single and multiple GPUs
* Pure C++ implementation with minimal depedencies on external packages (cuda,
  boost)
* Optionally static compilation of binaries
* Permissive open source license (MIT)

### Model features
* GRU-based bidirectional encoder, GRU-based decoder, multiplicative attention
mechanism;
* Layer normalization ([Ba et al. 2016](https://arxiv.org/abs/1607.06450)) -- faster
convergence and better test results;
* Dynamic batching -- adjust mini-batch size dynamically to maximize usage of
available or bounded memory, increases training throughput;
* Running average of parameters for inference -- better results at test time;
* Scaling dropout for RNN inputs and states, input and output embeddings;
* Asynchronous parallel SGD (model parallelism) with vanilla SGD, Adagrad,
or Adam -- faster training and better convergence;

### Experimental features
Experimental features are not available in the Amun translation tool and are
potentially unstable. They can be used with the (also experimental) Marian
translation only (slower and memory hungry in comparison to Amun). Useful
and proven features are likely to be implemented in Amun in the future.

* Multi-layer encoder/decoder
* Residual/skip connections between RNN layers
* Multi-source encoder



## Benchmarks

### Translation speed in words per second

The models used for the translation speed benchmarks have been described in
the [IWSLT paper](http://workshop2016.iwslt.org/downloads/IWSLT_2016_paper_4.pdf).

![Translation speed #1]({{ site.baseurl }}/assets/images/translation_speed.png)

We ran our experiments on an Intel Xeon E5-2620 2.40GHz server with four NVIDIA
GeForce GTX 1080 GPUs.We present the words-per-second ratio for our NMT models
using Marian and Nematus, executed on the CPU and GPU. For the CPU version we
use 16 threads, translating one sentence per thread. We restrict the number of
OpenBLAS threads to 1 per main Nematus thread. For the GPU version of Nematus
we use 5 processes to maximize GPU saturation. As a baseline, the phrase-based
model reaches 455 words per second using 16 threads.

The CPU-bound execution of Nematus reaches 47 words per second while the
GPU-bound achieved 270 words per second. In similar settings, CPU-bound Marian
is three times faster than Nematus CPU, but three times slower than Moses. With
vocabulary selection (systems with asteriks) we can nearly double the speed of
Marian CPU. The GPU-executed version of Marian is more than three times faster
than Nematus and nearly twice as fast as Moses, achieving 865 words per second,
with vocabulary selection we reach 1,192. Even the speed of the CPU version
would already allow to replace a Moses-based SMT system with an Marian-based
NMT system in a production environment without severely affecting translation
throughput.

![Translation speed #2]({{ site.baseurl }}/assets/images/translation_speed2.png)

Amun also features "batched" translation, i.e. multiple sentences are being
translated at once on a single GPU. Since computation time for matrix products
on the GPU increases sub-linearly with regard to matrix size, we can take
advantage of this by pushing multiple translation through the neural network.
For the same models as above and a batch-size of 200 (beam-size 5) we achieve
over 5000 words per second on one GPU. This scales linearly to the number of
GPUs used. As before, the asteriks marks systems with vocabulary filtering.
Systems "Single" and "Single\*" are the same as two best systems in the first
graph.

### Training speed in words per second

We also compare training speed between a number of popular toolkits and Marian.
As Marian is still early work, we expect speed to improve with future optimizations.

<div class="multiple-images">
  <img alt="Training speed #1" src="{{ site.baseurl }}/assets/images/train.speed500.png"/>
  <img att="Training speed #2" src="{{ site.baseurl }}/assets/images/train.speed1024.png"/>
</div>

We compare models with standard settings and comparable embedding, hidden layer and batch sizes.
The first graph (blue bars) corresponds to the model parameters described in the
[OpenNMT paper](https://arxiv.org/abs/1701.02810),
the second (green bars) corresponds to Nematus default settings for embedding and hidden layer
sizes. In both cases we use a vocabulary size of 32,000 subword units. The models were trained
on German-English WMT data. Nematus-array is Nematus run with the new Cuda backend libgpuarray.

### Multi-GPU training

Marian's training framework provides multi-GPU training via asynchronous SGD and
data parallelism (copies of the full model on each GPU). We benchmarked
the [Romanian-English example](/examples/training/) on a machine with
8 NVIDIA GTX 1080 GPUs. Training speed increases with each GPU instance, but currently
the increase is sub-linear. Using 4-5 GPUs seems optimal, for more GPUs it might be worth
to use them for another training run.

![Multi GPU]({{ site.baseurl }}/assets/images/multi_gpu.png)

Our current version of asynchronous SGD is delay-free, i.e. that all (sharded) gradients
are propagated to all GPUs for each update. In the future we will introduce delayed updates
which should result in a more linear performance increase with each additional GPU.
