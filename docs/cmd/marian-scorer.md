---
layout: docs
title: Command-line options for marian-scorer
permalink: /docs/cmd/marian-scorer/
icon: fa-file-code-o
---

Usage: `./marian/build/marian-scorer [OPTIONS]`

## General options
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

## Model options
```
-m,--model TEXT=model.npz             Path prefix for model to be saved/resumed. Supported file 
                                      extensions: .npz, .bin
--ignore-model-config                 Ignore the model configuration saved in npz file
--type TEXT=amun                      Model type: amun, nematus, s2s, multi-s2s, transformer
--dim-vocabs VECTOR=0,0 ...           Maximum items in vocabulary ordered by rank, 0 uses all 
                                      items in the provided/created vocabulary file
--dim-emb INT=512                     Size of embedding vector
--dim-rnn INT=1024                    Size of rnn hidden state
--enc-type TEXT=bidirectional         Type of encoder RNN : bidirectional, bi-unidirectional, 
                                      alternating (s2s)
--enc-cell TEXT=gru                   Type of RNN cell: gru, lstm, tanh (s2s)
--enc-cell-depth INT=1                Number of transitional cells in encoder layers (s2s)
--enc-depth INT=1                     Number of encoder layers (s2s)
--dec-cell TEXT=gru                   Type of RNN cell: gru, lstm, tanh (s2s)
--dec-cell-base-depth INT=2           Number of transitional cells in first decoder layer (s2s)
--dec-cell-high-depth INT=1           Number of transitional cells in next decoder layers (s2s)
--dec-depth INT=1                     Number of decoder layers (s2s)
--skip                                Use skip connections (s2s)
--layer-normalization                 Enable layer normalization
--right-left                          Train right-to-left model
--best-deep                           Use Edinburgh deep RNN configuration (s2s)
--special-vocab VECTOR ...            Model-specific special vocabulary ids
--tied-embeddings                     Tie target embeddings and output embeddings in output layer
--tied-embeddings-src                 Tie source and target embeddings
--tied-embeddings-all                 Tie all embedding layers and output layer
--transformer-heads INT=8             Number of heads in multi-head attention (transformer)
--transformer-no-projection           Omit linear projection after multi-head attention 
                                      (transformer)
--transformer-dim-ffn INT=2048        Size of position-wise feed-forward network (transformer)
--transformer-ffn-depth INT=2         Depth of filters (transformer)
--transformer-ffn-activation TEXT=swish
                                      Activation between filters: swish or relu (transformer)
--transformer-dim-aan INT=2048        Size of position-wise feed-forward network in AAN 
                                      (transformer)
--transformer-aan-depth INT=2         Depth of filter for AAN (transformer)
--transformer-aan-activation TEXT=swish
                                      Activation between filters in AAN: swish or relu (transformer)
--transformer-aan-nogate              Omit gate in AAN (transformer)
--transformer-decoder-autoreg TEXT=self-attention
                                      Type of autoregressive layer in transformer decoder: 
                                      self-attention, average-attention (transformer)
--transformer-tied-layers VECTOR ...  List of tied decoder layers (transformer)
--transformer-guided-alignment-layer TEXT=last
                                      Last or number of layer to use for guided alignment training 
                                      in transformer
--transformer-preprocess TEXT         Operation before each transformer layer: d = dropout, a = 
                                      add, n = normalize
--transformer-postprocess-emb TEXT=d  Operation after transformer embedding layer: d = dropout, a 
                                      = add, n = normalize
--transformer-postprocess TEXT=dan    Operation after each transformer layer: d = dropout, a = 
                                      add, n = normalize
```

## Scorer options
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
Version: 
v1.7.0 67124f8 2018-11-28 13:04:30 +0000
