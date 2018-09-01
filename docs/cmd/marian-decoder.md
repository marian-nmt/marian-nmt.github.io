---
layout: docs
title: Command-line options for marian-decoder
permalink: /docs/cmd/marian-decoder/
icon: fa-file-code-o
---


## General options
```
-c [ --config ] arg                                  Configuration file(s). If multiple, later overrides earlier.
-w [ --workspace ] arg (=512)                        Preallocate  arg  MB of work space
--log arg                                            Log training process information to file given by  arg
--log-level arg (=info)                              Set verbosity level of logging (trace - debug - info - warn - 
                                                     err(or) - critical - off)
--quiet                                              Suppress all logging to stderr. Logging to files still works
--quiet-translation                                  Suppress logging for translation
--seed arg (=0)                                      Seed for all random number generators. 0 means initialize 
                                                     randomly
--clip-gemm arg (=0)                                 If not 0 clip GEMM input values to +/- arg
--interpolate-env-vars                               allow the use of environment variables in paths, of the form 
                                                     ${VAR_NAME}
--relative-paths                                     All paths are relative to the config file location
--dump-config                                        Dump current (modified) configuration to stdout and exit
--version                                            Print version number and exit
-h [ --help ]                                        Print this help message and exit
```

## Model options
```
-m [ --models ] arg                                  Paths to model(s) to be loaded
--ignore-model-config                                Ignore the model configuration saved in npz file
--type arg (=amun)                                   Model type: amun, nematus, s2s, multi-s2s, transformer
--dim-vocabs arg (=0 0)                              Maximum items in vocabulary ordered by rank, 0 uses all items 
                                                     in the provided/created vocabulary file
--dim-emb arg (=512)                                 Size of embedding vector
--dim-rnn arg (=1024)                                Size of rnn hidden state
--enc-type arg (=bidirectional)                      Type of encoder RNN : bidirectional, bi-unidirectional, 
                                                     alternating (s2s)
--enc-cell arg (=gru)                                Type of RNN cell: gru, lstm, tanh (s2s)
--enc-cell-depth arg (=1)                            Number of transitional cells in encoder layers (s2s)
--enc-depth arg (=1)                                 Number of encoder layers (s2s)
--dec-cell arg (=gru)                                Type of RNN cell: gru, lstm, tanh (s2s)
--dec-cell-base-depth arg (=2)                       Number of transitional cells in first decoder layer (s2s)
--dec-cell-high-depth arg (=1)                       Number of transitional cells in next decoder layers (s2s)
--dec-depth arg (=1)                                 Number of decoder layers (s2s)
--skip                                               Use skip connections (s2s)
--layer-normalization                                Enable layer normalization
--right-left                                         Train right-to-left model
--best-deep                                          Use Edinburgh deep RNN configuration (s2s)
--special-vocab arg                                  Model-specific special vocabulary ids
--tied-embeddings                                    Tie target embeddings and output embeddings in output layer
--tied-embeddings-src                                Tie source and target embeddings
--tied-embeddings-all                                Tie all embedding layers and output layer
--transformer-heads arg (=8)                         Number of heads in multi-head attention (transformer)
--transformer-no-projection                          Omit linear projection after multi-head attention 
                                                     (transformer)
--transformer-dim-ffn arg (=2048)                    Size of position-wise feed-forward network (transformer)
--transformer-ffn-depth arg (=2)                     Depth of filters (transformer)
--transformer-ffn-activation arg (=swish)            Activation between filters: swish or relu (transformer)
--transformer-dim-aan arg (=2048)                    Size of position-wise feed-forward network in AAN 
                                                     (transformer)
--transformer-aan-depth arg (=2)                     Depth of filter for AAN (transformer)
--transformer-aan-activation arg (=swish)            Activation between filters in AAN: swish or relu (transformer)
--transformer-aan-nogate                             Omit gate in AAN (transformer)
--transformer-decoder-autoreg arg (=self-attention)  Type of autoregressive layer in transformer decoder: 
                                                     self-attention, average-attention (transformer)
--transformer-tied-layers arg                        List of tied decoder layers (transformer)
--transformer-guided-alignment-layer arg (=last)     Last or number of layer to use for guided alignment training 
                                                     in transformer
--transformer-preprocess arg                         Operation before each transformer layer: d = dropout, a = add,
                                                     n = normalize
--transformer-postprocess-emb arg (=d)               Operation after transformer embedding layer: d = dropout, a = 
                                                     add, n = normalize
--transformer-postprocess arg (=dan)                 Operation after each transformer layer: d = dropout, a = add, 
                                                     n = normalize
```

## Translator options
```
-i [ --input ] arg (=stdin)                          Paths to input file(s), stdin by default
-v [ --vocabs ] arg                                  Paths to vocabulary files have to correspond to --input
-b [ --beam-size ] arg (=12)                         Beam size used during search
-n [ --normalize ] [=arg(=1)] (=0)                   Divide translation score by pow(translation length, arg) 
--word-penalty [=arg(=0)] (=0)                       Subtract (arg * translation length) from translation score 
--allow-unk                                          Allow unknown words to appear in output
--skip-cost                                          Ignore model cost during translation, not recommended for 
                                                     beam-size > 1
--max-length arg (=1000)                             Maximum length of a sentence in a training sentence pair
--max-length-factor arg (=3)                         Maximum target length as source length times factor
--max-length-crop                                    Crop a sentence to max-length instead of ommitting it if 
                                                     longer than max-length
-d [ --devices ] arg (=0)                            GPUs to use for translating
--cpu-threads [=arg(=1)] (=0)                        Use CPU-based computation with this many independent threads, 
                                                     0 means GPU-based computation
--optimize                                           Optimize speed aggressively sacrificing memory or precision
--mini-batch arg (=1)                                Size of mini-batch used during update
--mini-batch-words arg (=0)                          Set mini-batch size based on words instead of sentences
--maxi-batch arg (=1)                                Number of batches to preload for length-based sorting
--maxi-batch-sort arg (=none)                        Sorting strategy for maxi-batch: none, src
--n-best                                             Display n-best list
--shortlist arg                                      Use softmax shortlist: path first best prune
--weights arg                                        Scorer weights
--alignment [=arg(=1)]                               Return word alignment. Possible values: 0.0-1.0, hard, soft
-p [ --port ] arg (=8080)                            Port number for web socket server
```
Version: 
v1.6.0+8856ae9
