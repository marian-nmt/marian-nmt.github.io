---
layout: docs
title: Command-line options for marian-decoder
permalink: /docs/cmd/1.7.0/marian-decoder/
icon: fa-file-code-o
---

## marian-decoder
Version: 
v1.7.0 67124f8 2018-11-28 13:04:30 +0000

Usage: `./marian/build/marian-decoder [OPTIONS]`

### General options
```
-h,--help                             Print this help message and exit
--version                             Print the version number and exit
-c,--config VECTOR ...                Configuration file(s). If multiple, later overrides earlier
-w,--workspace UINT=512               Preallocate  arg  MB of work space
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

### Translator options
```
-i,--input VECTOR=stdin ...           Paths to input file(s), stdin by default
-o,--output TEXT=stdout               Paths to output file(s), stdout by default
-v,--vocabs VECTOR ...                Paths to vocabulary files have to correspond to --input
-b,--beam-size UINT=12                Beam size used during search with validating translator
-n,--normalize FLOAT=0                Divide translation score by pow(translation length, arg)
--max-length-factor FLOAT=3           Maximum target length as source length times factor
--word-penalty FLOAT                  Subtract (arg * translation length) from translation score
--allow-unk                           Allow unknown words to appear in output
--n-best                              Generate n-best list
--alignment TEXT                      Return word alignment. Possible values: 0.0-1.0, hard, soft
-d,--devices VECTOR=0 ...             Specifies GPU ID(s) to use for training. Defaults to 
                                      0..num-devices-1
--num-devices UINT                    Number of GPUs to use for this process. Defaults to 
                                      length(devices) or 1
--cpu-threads UINT=0                  Use CPU-based computation with this many independent 
                                      threads, 0 means GPU-based computation
--max-length UINT=1000                Maximum length of a sentence in a training sentence pair
--max-length-crop                     Crop a sentence to max-length instead of ommitting it if 
                                      longer than max-length
--mini-batch INT=1                    Size of mini-batch used during batched translation
--mini-batch-words INT                Set mini-batch size based on words instead of sentences
--maxi-batch INT=1                    Number of batches to preload for length-based sorting
--maxi-batch-sort TEXT=none           Sorting strategy for maxi-batch: none, src, trg (not 
                                      available for decoder)
--shuffle-in-ram                      Keep shuffled corpus in RAM, do not write to temp file
--optimize                            Optimize speed aggressively sacrificing memory or precision
--skip-cost                           Ignore model cost during translation, not recommended for 
                                      beam-size > 1
--shortlist VECTOR ...                Use softmax shortlist: path first best prune
--weights VECTOR ...                  Scorer weights
--output-sampling=false               Noise output layer with gumbel noise
-p,--port UINT                        Port number for web socket server
--ulr=false                           Enable ULR (Universal Language Representation)
--ulr-query-vectors TEXT              Path to file with universal sources embeddings from 
                                      projection into universal space
--ulr-keys-vectors TEXT               Path to file with universal sources embeddings of traget 
                                      keys from projection into universal space
--ulr-trainable-transformation=false  Make Query Transformation Matrix A trainable
--ulr-dim-emb INT                     ULR monolingual embeddings dimension
--ulr-dropout FLOAT=0                 ULR dropout on embeddings attentions. Default is no dropout
--ulr-softmax-temperature FLOAT=1     ULR softmax temperature to control randomness of 
                                      predictions. Deafult is 1.0: no temperature
```
