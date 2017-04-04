---
layout: docs
title: Features & Benchmarks
permalink: /features/
icon: fa-bar-chart-o
menu: 2
---

## Features

### General
* Up to 15x faster translation than Nematus and similar toolkits on a single GPU
* Up to 2x faster training than toolkits based on Theano, Tensorflow, Torch on a single GPU
* Binary/model-compatible with [DL4MT](https://github.com/nyu-dl/dl4mt-tutorial) and [Nematus](https://github.com/rsennrich/nematus) models
* Multi-GPU training and translation
* Batched translation on single and multiple GPUs
* Pure C++ implementation with minimal depedencies on external packages
* Optionally static compilation of binaries

## Benchmarks

### Translation speed in words per second

The models used for the translation speed benchmarks have been described in
this [paper](http://workshop2016.iwslt.org/downloads/IWSLT_2016_paper_4.pdf).

<table style="border-collapse: separate; border-spacing: 40px; margin: auto">
<tr>
  <td><img style="border: 1px solid black;" src="{{site.baseurl}}../assets/images/translation_speed.png"/></td>
</tr>
</table>

We ran our experiments on an Intel Xeon E5-2620
2.40GHz server with four NVIDIA GeForce GTX 1080
GPUs.We present the words-per-second ratio for our NMT
models using AmuNMT and Nematus, executed on the
CPU and GPU. For the CPU version we use
16 threads, translating one sentence per thread. We restrict
the number of OpenBLAS threads to 1 per main
Nematus thread. For the GPU version of Nematus we
use 5 processes to maximize GPU saturation. As a baseline,
the phrase-based model reaches 455 words per second
using 16 threads.

The CPU-bound execution of Nematus reaches
47 words per second while the GPU-bound achieved
270 words per second. In similar settings, CPU-bound
AmuNMT is three times faster than Nematus CPU,
but three times slower than Moses. With vocabulary
selection (systems with asteriks) we can nearly double the speed of AmuNMT
CPU. The GPU-executed version of AmuNMT is more
than three times faster than Nematus and nearly twice
as fast as Moses, achieving 865 words per second, with
vocabulary selection we reach 1,192. Even the speed
of the CPU version would already allow to replace a
Moses-based SMT system with an AmuNMT-based
NMT system in a production environment without
severely affecting translation throughput.

<table style="border-collapse: separate; border-spacing: 40px; margin: auto">
<tr>
  <td><img style="border: 1px solid black;" src="{{site.baseurl}}../assets/images/translation_speed2.png"/></td>
</tr>
</table>

Amun also features "batched" translation, i.e. multiple sentences are being translated at once
on a single GPU. Since computation time for matrix products on the GPU increases sub-linearly
with regard to matrix size, we can take advantage of this by pushing multiple translation
through the neural network. For the same models as above and a batch-size of 200 (beam-size 5)
we achieve over 5000 words per second on one GPU. This scales linearly to the number of GPUs
used. As before, the asteriks marks systems with vocabulary filtering. Systems "Single" and "Single*"
are the same as two best systems in the first graph.

### Training speed in words per second

We also compare training speed between a number of popular toolkits and AmuNMT.
As AmuNMT is still early work, we expect speed to improve with future optimizations. 

<table style="border-collapse: separate; border-spacing: 40px; margin: auto">
<tr>
  <td><img style="border: 1px solid black;" src="{{site.baseurl}}../assets/images/training_speed.png"/></td>
  <td><img style="border: 1px solid black;" src="{{site.baseurl}}../assets/images/training_speed2.png"/></td>
</tr>
</table>

We compare models with standard setting and comparable embedding, hidden layer and batch sizes.
The first graph (blue bars) corresponds to the model parameters described in the [OpenNMT paper](http://),
the second (green bars) corresponds to Nematus standard settings for embedding and hidden layer
sizes. In both cases we use a vocabulary size of 32,000 subword units. The models were trained
on German-English WMT data.

### Multi-GPU training

