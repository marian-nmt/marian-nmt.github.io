---
layout: docs
title: Features & Benchmarks
permalink: /features/
icon: fa-bar-chart-o
menu: 2
---

## Features

* Up to 15x faster translation than Nematus and similar toolkits on a single GPU
* Up to 2x faster training than toolkits based on Theano, Tensorflow, Torch on a single GPU
* Binary/model-compatible with [DL4MT](https://github.com/nyu-dl/dl4mt-tutorial) and [Nematus](https://github.com/rsennrich/nematus) models
* Multi-GPU training and translation
* Batched translation on single and multiple GPUs
* Pure C++ implementation with minimal depedencies on external packages
* Optionally static compilation of binaries

## Benchmarks

### Translation speed in words per second

### Training speed in words per second

<table style="border-collapse: separate; border-spacing: 40px">
<tr>
  <td><img style="border: 1px solid black;" src="{{site.baseurl}}../assets/images/training_speed.png"/></td>
  <td><img style="border: 1px solid black;" src="{{site.baseurl}}../assets/images/training_speed2.png"/></td>
</tr>
</table>
