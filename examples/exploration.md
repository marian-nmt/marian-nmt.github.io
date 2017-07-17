---
layout: docs
title: An Exploration of Neural Sequence-to-Sequence Architectures for Automatic Post-Editing
permalink: /examples/exploration/
icon: fa-cogs
---

This page provides data, model files and training instructions for our APE system described in [An Exploration of Neural Sequence-to-Sequence Architectures for Automatic Post-Editing](https://arxiv.org/abs/1706.04138).
If you use any of the data, systems or ideas, please cite:

    @InProceedings{junczysdowmunt-grundkiewicz:2016:WMT,
       author    = {Marcin Junczys-Dowmunt and Roman Grundkiewicz},
       title     = {An Exploration of Neural Sequence-to-Sequence Architectures for Automatic Post-Editing},
       year      = {2017},
       url       = {https://arxiv.org/abs/1706.04138}
    }

## Reproducing our results

### Tools and data
Create a new working folder and enter that folder:

```
mkdir ape-explore
cd ape-explore
```

Download and compile Marian. This is our training and translation toolkit.
```
git clone https://github.com/marian-nmt/marian
cd marian
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j16
cd ../..
```

Download and compile Moses. We use the TER scorer in Moses for reporting of validation results during training.
```
git clone https://github.com/moses-smt/mosesdecoder
cd mosesdecoder
./bjam -j16
cd ..
```

Obtain the already preprocessed training data as described below. The data has been prepared in such a way that training can be executed immediately. The included `Makefile` can be used to retrace the preprocessing steps. The folder train/data.all contains the raw unprocessed training and test data. The data has been created using the official training data for the [WMT 2016 APE task](http://www.statmt.org/wmt16/ape-task.html) and the artifical data made available [here](../postedit).
```
wget http://data.statmt.org/romang/ape-explore/train.tgz
tar -xzf train.tgz
cd train
```

### Training with a chosen configuration

Inside the `train` folder there is a set of YAML configuration files, one for each model type introduced in our paper. The configuration files can also be obtained separatly [here](http://www.data.statmt.org/romang/ape-explore/config.tgz).
Train a model by using its configuration file. Here we chose the dual-source model `m-cgru` from the paper.

Type the following command to train on four GPUs:
```
../marian/build/marian -c config/m-cgru.yml -d 0 1 2 3
```

which will produce model files in the `models/m-cgru` folder. Example output during training would look roughly like this:

```
[2017-07-10 23:28:47] Ep. 1 : Up. 1000 : Sen. 64000 : Cost 129.47 : Time 201.87s : 5814.94 words/s
[2017-07-10 23:31:33] Ep. 1 : Up. 2000 : Sen. 128000 : Cost 104.59 : Time 166.06s : 7060.59 words/s
[2017-07-10 23:34:16] Ep. 1 : Up. 3000 : Sen. 192000 : Cost 89.37 : Time 163.62s : 7185.44 words/s
[2017-07-10 23:37:02] Ep. 1 : Up. 4000 : Sen. 256000 : Cost 77.24 : Time 166.10s : 7062.50 words/s
[2017-07-10 23:39:47] Ep. 1 : Up. 5000 : Sen. 320000 : Cost 69.96 : Time 164.44s : 7174.16 words/s
[2017-07-10 23:42:33] Ep. 1 : Up. 6000 : Sen. 384000 : Cost 63.79 : Time 166.52s : 7034.91 words/s
[2017-07-10 23:45:22] Ep. 1 : Up. 7000 : Sen. 448000 : Cost 59.78 : Time 168.35s : 6984.08 words/s
[2017-07-10 23:48:06] Ep. 1 : Up. 8000 : Sen. 512000 : Cost 56.00 : Time 164.65s : 7117.06 words/s
[2017-07-10 23:50:50] Ep. 1 : Up. 9000 : Sen. 576000 : Cost 53.39 : Time 163.57s : 7176.63 words/s
[2017-07-10 23:53:34] Ep. 1 : Up. 10000 : Sen. 640000 : Cost 51.26 : Time 164.56s : 7145.62 words/s
[2017-07-10 23:53:34] Saving model to models/m-cgru/model.iter10000.npz
[2017-07-10 23:53:35] Saving model to models/m-cgru/model.npz
[2017-07-10 23:53:38] [valid] 10000 : cross-entropy : 38.332 : new best
[2017-07-10 23:53:38] Saving model to models/m-cgru/model.npz.dev.npz
[2017-07-10 23:54:22] [valid] 10000 : valid-script : 0.6483 : new best
[2017-07-10 23:57:06] Ep. 1 : Up. 11000 : Sen. 704000 : Cost 48.64 : Time 211.14s : 5554.63 words/s
[2017-07-10 23:59:53] Ep. 1 : Up. 12000 : Sen. 768000 : Cost 47.09 : Time 167.37s : 7012.21 words/s
```
The reported figures coming from the validation script are `1-TER` as produced by the Moses scorer, thus higher is better.

Inspect `models/m-cgru/validate.sh` or the example below to see how translation and validation works. For ensembling back-up the recently trained model (or move the folder `models/m-cgru`) and restart training with the same config file. Weights will be initialized to different random weights.

In order to create and validate the averaged model (an element-wise average of model weights) run:
```
./models/m-cgru/validate_avg.sh
```
This will create the averaged model `m-cgru/model.avg.npz` and validate on the official WMT 2016 test set, reporting BLEU with `../mosesdecoder/scripts/generic/multi-bleu.pl` and the official APE task scorer from `eval`. Results for averaged models from one training run are usually slightly better. Do not attempt to average models from different training runs, this will not work.

## Models and config files

Coming soon.


