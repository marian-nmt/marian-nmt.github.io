---
layout: docs
title: Winning system of the WMT 2016 APE shared task
permalink: /examples/postedit/
icon: fa-cogs
---

**Works with commit: 3833669**

This page provides data and model files for our shared task winning APE system described in [Log-linear Combinations of Monolingual and Bilingual Neural Machine Translation Models for Automatic Post-Editing](http://www.aclweb.org/anthology/W16-2378). If you use any of the data, systems or ideas, please cite:

    @InProceedings{junczysdowmunt-grundkiewicz:2016:WMT,
       author    = {Junczys-Dowmunt, Marcin  and  Grundkiewicz, Roman},
       title     = {Log-linear Combinations of Monolingual and Bilingual Neural Machine Translation Models for Automatic Post-Editing},
       booktitle = {Proceedings of the First Conference on Machine Translation},
       month     = {August},
       year      = {2016},
       address   = {Berlin, Germany},
       publisher = {Association for Computational Linguistics},
       pages     = {751--758},
       url       = {http://www.aclweb.org/anthology/W16-2378}
    }


## Artificially created data
[Download the training data](http://odkrywka.wmi.amu.edu.pl/static/data/ape/data.tgz) (514M)

This file contains the artificially generated post-editing triplets described in Table 1 of the paper. "4M" is the larger set denoted as "round-trip.n10" in that table, 500K is the smaller set denoted as "round-trip.n1". The 20 times oversampled original training data for the shared task is not included, but can be obtained from the original [shared task page](http://www.statmt.org/wmt16/ape-task.html).

    data
    ├── 4M
    │   ├── 4M.mt
    │   ├── 4M.pe
    │   └── 4M.src
    └── 500K
        ├── 500K.mt
        ├── 500K.pe
        └── 500K.src

## Models and config files
[Download the systems](http://odkrywka.wmi.amu.edu.pl/static/data/ape/system.tgz) (2.7G)

We also provide the complete primary system and two contrastive variants. To create the submitted output, locate the ```Makefile``` and provide the path to the main directory of your working Marian tool (latest master, see [Readme](https://github.com/marian-nmt/marian/blob/master/README.md)) in the following line:

    AMUNMT=/home/marcinj/Badania/marian 

Next type ```make```. The included files should provide all input files, model files and scripts to produce our exact submission. You may need to change the number of GPU devices, as the original configs assume three GPUs. In the end you should see the three submission files:

    AMU_ensemble8-mt+src_PRIMARY
    AMU_ensemble4-mt_CONTRASTIVE
    AMU_ensemble4-src_CONTRASTIVE

The configuration file for the best ensemble ```models/configs/mtsrc-pe.ensemble.ape.tuned.yml``` has been included below. It assumes the presence and availability of three GPUs in the line ```devices: [0, 1, 2]```, you want to change it to one device by ```devices: [0]```. 

    # amunn config file

    relative-paths: yes

    # Scorer configuration
    scorers:
      F0:
        type: Nematus
        path: ../mt-pe/model.iter260000.npz
      F1:
        type: Nematus
        path: ../mt-pe/model.iter270000.npz
      F2:
        type: Nematus
        path: ../mt-pe/model.iter280000.npz
      F3:
        type: Nematus
        path: ../mt-pe/model.iter290000.npz
      F4:
        type: Nematus
        path: ../src-pe/model.iter340000.npz
        tab: 1
      F5:
        type: Nematus
        path: ../src-pe/model.iter350000.npz
        tab: 1
      F6:
        type: Nematus
        path: ../src-pe/model.iter360000.npz
        tab: 1
      F7:
        type: Nematus
        path: ../src-pe/model.iter370000.npz
        tab: 1
      F8:
        type: APE

    source-vocab:
      - ../mt-pe/vocab.mt.json
      - ../src-pe/vocab.src.json
    target-vocab: ../mt-pe/vocab.pe.json

    weights:
      F0: 0.0679875234050288
      F1: 0.136272622440232
      F2: 0.0447424881348462
      F3: 0.0505810091549122
      F4: 0.119029214497868
      F5: -0.0291262004966649
      F6: -0.0348248568202612
      F7: 0.131424048800743
      F8: 0.386012036249443

    beam-size: 12
    normalize: yes
    n-best: no

    devices: [0, 1, 2]
    threads-per-device: 1

In the future we will provide more hints on how to train a similar system. Currently we supply the following files:

    system
    ├── data
    │   ├── de.bpe
    │   ├── en.bpe
    │   ├── true.de
    │   └── true.en
    ├── Makefile
    ├── models
    │   ├── configs
    │   │   ├── mt-pe.ensemble4.tuned.yml
    │   │   ├── mtsrc-pe.ensemble.ape.tuned.yml
    │   │   └── src-pe.ensemble4.yml
    │   ├── mt-pe
    │   │   ├── model.iter260000.npz
    │   │   ├── model.iter270000.npz
    │   │   ├── model.iter280000.npz
    │   │   ├── model.iter290000.npz
    │   │   ├── vocab.mt.json
    │   │   └── vocab.pe.json
    │   └── src-pe
    │       ├── model.iter340000.npz
    │       ├── model.iter350000.npz
    │       ├── model.iter360000.npz
    │       ├── model.iter370000.npz
    │       ├── vocab.pe.json
    │       └── vocab.src.json
    ├── scripts
    │   ├── apply_bpe.py
    │   ├── deescape-special-chars.perl
    │   ├── detruecase.perl
    │   ├── escape-special-chars.perl
    │   ├── prepare_submission.py
    │   └── truecase.perl
    └── test
        ├── test.mt
        └── test.src

where ```data``` contains truecasing models and BPE codes. ```models/configs``` provides the configuration files for ```amun``` to load the model ensembles located in ```mt-pe``` (monolingual model, trained on MT-output and post-editing data) and ```src-pe``` (bilingual model, trained on source and post-editing data). ```test``` contains the blind test set, ground truth and evaluation scripts are again available from the [shared task page](http://www.statmt.org/wmt16/ape-task.html).
