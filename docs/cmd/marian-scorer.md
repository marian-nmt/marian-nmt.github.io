---
layout: docs
title: Command-line options for marian-scorer
permalink: /docs/cmd/marian-scorer/
icon: fa-file-code-o
---

## marian-scorer
Version: 
v1.7.0 67124f8 2018-11-28 13:04:30 +0000

Usage: `./marian/build/marian-scorer [OPTIONS]`

### General options
```
-h,--help                             Print this help message and exit
--version                             Print the version number and exit
-c,--config VECTOR ...                Configuration file(s). If multiple, later overrides earlier
-w,--workspace UINT=2048              Preallocate  arg  MB of work space
--log TEXT                            Log training process information to file given by  arg
--log-level TEXT=info                 Set verbosity level of logging: trace, debug, info, warn, 
                                      err(or), critical, off
--log-time-zone TEXT                  Set time zone for the date shown on logging
--quiet                               Suppress all logging to stderr. Logging to files still works
--quiet-translation                   Suppress logging for translation
--seed UINT                           Seed for all random number generators. 0 means initialize 
                                      randomly
--clip-gemm FLOAT                     If not 0 clip GEMM input values to +/- arg
--interpolate-env-vars                allow the use of environment variables in paths, of the form 
                                      ${VAR_NAME}
--relative-paths                      All paths are relative to the config file location
--dump-config TEXT                    Dump current (modified) configuration to stdout and exit. 
                                      Possible values: full, minimal
```

### Scorer options
```
--no-reload                           Do not load existing model specified in --model arg
-t,--train-sets VECTOR ...            Paths to corpora to be scored: source target
-v,--vocabs VECTOR ...                Paths to vocabulary files have to correspond to 
                                      --train-sets. If this parameter is not supplied we look for 
                                      vocabulary files source.{yml,json} and target.{yml,json}. 
                                      If these files do not exists they are created
--n-best                              Score n-best list instead of plain text corpus
--n-best-feature TEXT=Score           Feature name to be inserted into n-best list
--summary TEXT                        Only print total cost, possible values: cross-entropy 
                                      (ce-mean), ce-mean-words, ce-sum, perplexity
--alignment TEXT                      Return word alignments. Possible values: 0.0-1.0, hard, soft
--max-length UINT=1000                Maximum length of a sentence in a training sentence pair
--max-length-crop                     Crop a sentence to max-length instead of ommitting it if 
                                      longer than max-length
-d,--devices VECTOR=0 ...             Specifies GPU ID(s) to use for training. Defaults to 
                                      0..num-devices-1
--num-devices UINT                    Number of GPUs to use for this process. Defaults to 
                                      length(devices) or 1
--cpu-threads UINT=0                  Use CPU-based computation with this many independent 
                                      threads, 0 means GPU-based computation
--mini-batch INT=64                   Size of mini-batch used during batched scoring
--mini-batch-words INT                Set mini-batch size based on words instead of sentences
--maxi-batch INT=100                  Number of batches to preload for length-based sorting
--maxi-batch-sort TEXT=trg            Sorting strategy for maxi-batch: none, src, trg (not 
                                      available for decoder)
--shuffle-in-ram                      Keep shuffled corpus in RAM, do not write to temp file
--optimize                            Optimize speed aggressively sacrificing memory or precision
```
