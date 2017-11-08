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
* Multi-GPU training and translation
* Pure C++ implementation with minimal depedencies on external packages (CUDA,
  Boost)
* Optionally static compilation of binaries
* Different types of models, including deep RNNs, transformer and language model
* Binary/model-compatible with [Nematus](https://github.com/EdinburghNLP/nematus)
  models for certain model types
* C++ web-socket service for translation
* CPU translation with Amun for certain model types
* Batched translation on single and multiple GPU/CPUs with Amun
* Permissive open source license (MIT)

### Model features
* Deep RNNs with Deep Transition Cells ([Miceli Barone et al.
  2017](http://aclweb.org/anthology/W17-4710))
* Transformer models ([Vaswani et al.
  2017](https://arxiv.org/abs/1706.03762))
* Encoder types: bidirectional, uni-bidirectional, alternating
* LSTM cell instead of GRU
* Layer normalization ([Ba et al. 2016](https://arxiv.org/abs/1607.06450))
* Residual/skip connections between RNN layers
* Scaling dropout for RNN inputs and states, input and output embeddings ([Gal
  and Ghahramani, 2016](https://arxiv.org/abs/1512.05287))
* Tied embeddings ([Press and Wolf, 2017](https://arxiv.org/abs/1608.05859))
* Deep RNN language models

### Training features
* Adjusting mini-batch size dynamically to maximize usage of available or
  bounded memory
* Asynchronous/synchronous parallel SGD (data parallelism) with vanilla SGD,
  Adagrad, or Adam
* Multi-GPU validation and in-training translation
* Exposed optimizer parameters
* Moving average of parameters
* Decaying and warmup strategies for learning rate
* Custom word embeddings from [word2vec](https://github.com/dav/word2vec)
* Guided alignment to guide attention
* Rescoring outputs

### Experimental features
Experimental features are available only in the Marian decoder.

* Dual-source models for Automatic Post Editing ([Junczys-Dowmunt and
  Grundkiewicz, 2017](https://arxiv.org/abs/1706.04138))
* Character-level convolutional models ([Lee et al.
  2017](https://arxiv.org/abs/1610.03017))

## Benchmarks

### Translation speed

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

### Training speed

We also compare training speed between a number of popular toolkits and Marian.
As Marian is still early work, we expect speed to improve with future optimizations.
The numbers reported in this section have been computed on a single GPU.

<div class="multiple-images">
  <img alt="Training speed #1" src="{{ site.baseurl }}/assets/images/train.speed500.png"/>
  <img att="Training speed #2" src="{{ site.baseurl }}/assets/images/train.speed1024.png"/>
</div>

We compare models with standard settings and comparable embedding, hidden layer and batch sizes.
The first graph corresponds to the model parameters described in the
[OpenNMT paper](https://arxiv.org/abs/1701.02810),
the second corresponds to Nematus default settings for embedding and hidden layer
sizes. In both cases we use a vocabulary size of 32,000 subword units. The models were trained
on German-English WMT data. Nematus-array is Nematus run with the new Cuda backend libgpuarray.
Blue bars describe training speed on a NVIDIA GTX 1080 GPU, green bars on a Titan X with Pascal
architecture.

### Multi-GPU training

Marian's training framework provides multi-GPU training via
synchronous/asynchronous SGD and data parallelism (copies of the full model on
each GPU). 
We benchmarked the [Romanian-English example](/examples/training/) on a machine
with 8 NVIDIA P100 GPUs. Training speed increases with each GPU instance.
The increase for synchronous SGD is sub-linear, but it may allow to achieve
lower cross-entropy score for certain model types, which may be not achievable
with asynchronous SGD. 

![Multi GPU]({{ site.baseurl }}/assets/images/multi_gpu.png)
{: width="90%"}

Our current version of asynchronous SGD is delay-free, i.e. that all (sharded)
gradients are propagated to all GPUs for each update. In the future we will
introduce delayed updates which should result in a more linear performance
increase with each additional GPU.
