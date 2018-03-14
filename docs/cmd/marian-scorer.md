---
layout: docs
title: Command-line options for marian-scorer
permalink: /docs/cmd/marian-scorer/
icon: fa-file-code-o
---


## General options
```
-c [ --config ] arg                        Configuration file
-w [ --workspace ] arg (=2048)             Preallocate  arg  MB of work space
--log arg                                  Log training process information to file given by  arg
--log-level arg (=info)                    Set verbosity level of logging (trace - debug - info - warn - err(or) - critical - off)
--quiet                                    Suppress all logging to stderr. Logging to files still works
--quiet-translation                        Suppress logging for translation
--seed arg (=0)                            Seed for all random number generators. 0 means initialize randomly
--relative-paths                           All paths are relative to the config file location
--dump-config                              Dump current (modified) configuration to stdout and exit
--version                                  Print version number and exit
-h [ --help ]                              Print this help message and exit
```

## Model options
```
-m [ --model ] arg (=model.npz)            Path prefix for model to be saved/resumed
--ignore-model-config                      Ignore the model configuration saved in npz file
--type arg (=amun)                         Model type (possible values: amun, nematus, s2s, multi-s2s, transformer)
--dim-vocabs arg (=0 0)                    Maximum items in vocabulary ordered by rank, 0 uses all items in the provided/created vocabulary file
--dim-emb arg (=512)                       Size of embedding vector
--dim-rnn arg (=1024)                      Size of rnn hidden state
--enc-type arg (=bidirectional)            Type of encoder RNN : bidirectional, bi-unidirectional, alternating (s2s)
--enc-cell arg (=gru)                      Type of RNN cell: gru, lstm, tanh (s2s)
--enc-cell-depth arg (=1)                  Number of transitional cells in encoder layers (s2s)
--enc-depth arg (=1)                       Number of encoder layers (s2s)
--dec-cell arg (=gru)                      Type of RNN cell: gru, lstm, tanh (s2s)
--dec-cell-base-depth arg (=2)             Number of transitional cells in first decoder layer (s2s)
--dec-cell-high-depth arg (=1)             Number of transitional cells in next decoder layers (s2s)
--dec-depth arg (=1)                       Number of decoder layers (s2s)
--skip                                     Use skip connections (s2s)
--layer-normalization                      Enable layer normalization
--right-left                               Train right-to-left model
--best-deep                                Use Edinburgh deep RNN configuration (s2s)
--special-vocab arg                        Model-specific special vocabulary ids
--tied-embeddings                          Tie target embeddings and output embeddings in output layer
--tied-embeddings-src                      Tie source and target embeddings
--tied-embeddings-all                      Tie all embedding layers and output layer
--transformer-heads arg (=8)               Number of head in multi-head attention (transformer)
--transformer-dim-ffn arg (=2048)          Size of position-wise feed-forward network (transformer)
--transformer-ffn-activation arg (=swish)  Activation between filters: swish or relu (transformer)
--transformer-preprocess arg               Operation before each transformer layer: d = dropout, a = add, n = normalize
--transformer-postprocess-emb arg (=d)     Operation after transformer embedding layer: d = dropout, a = add, n = normalize
--transformer-postprocess arg (=dan)       Operation after each transformer layer: d = dropout, a = add, n = normalize
```

## Rescorer options
```
--no-reload                                Do not load existing model specified in --model arg
-t [ --train-sets ] arg                    Paths to corpora to be scored: source target
-v [ --vocabs ] arg                        Paths to vocabulary files have to correspond to --train-sets. If this parameter is not supplied we look for vocabulary files 
                                           source.{yml,json} and target.{yml,json}. If these files do not exists they are created
--n-best                                   Score n-best list instead of plain text corpus
--n-best-feature arg (=Score)              Feature name to be inserted into n-best list
--summary [=arg(=cross-entropy)]           Only print total cost, possible values: cross-entropy (ce-mean), ce-mean-words, ce-sum, perplexity
--max-length arg (=1000)                   Maximum length of a sentence in a training sentence pair
--max-length-crop                          Crop a sentence to max-length instead of ommitting it if longer than max-length
-d [ --devices ] arg (=0)                  GPUs to use for training
--cpu-threads [=arg(=1)] (=0)              Use CPU-based computation with this many independent threads, 0 means GPU-based computation
--mini-batch arg (=64)                     Size of mini-batch used during update
--mini-batch-words arg (=0)                Set mini-batch size based on words instead of sentences
--maxi-batch arg (=100)                    Number of batches to preload for length-based sorting
--maxi-batch-sort arg (=trg)               Sorting strategy for maxi-batch: trg (default) src none
```
Version: 
v1.4.0+aa51cce
