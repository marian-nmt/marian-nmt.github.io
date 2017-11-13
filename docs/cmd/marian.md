---
layout: docs
title: Command-line options for marian
permalink: /docs/cmd/marian/
icon: fa-file-code-o
---


## General options
```
-c [ --config ] arg                         Configuration file
-w [ --workspace ] arg (=2048)              Preallocate  arg  MB of work space
--log arg                                   Log training process information to file given by  arg
--log-level arg (=info)                     Set verbosity level of logging (trace - debug - info - warn - err(or) - critical - off)
--quiet                                     Suppress all logging to stderr. Logging to files still works
--seed arg (=0)                             Seed for all random number generators. 0 means initialize randomly
--relative-paths                            All paths are relative to the config file location
--dump-config                               Dump current (modified) configuration to stdout and exit
--version                                   Print version number and exit
-h [ --help ]                               Print this help message and exit
```

## Model options
```
-m [ --model ] arg (=model.npz)             Path prefix for model to be saved/resumed
--type arg (=amun)                          Model type (possible values: amun, nematus, s2s, multi-s2s, transformer)
--dim-vocabs arg (=0 0)                     Maximum items in vocabulary ordered by rank, 0 uses all items in the provided/created vocabulary file
--dim-emb arg (=512)                        Size of embedding vector
--dim-rnn arg (=1024)                       Size of rnn hidden state
--enc-type arg (=bidirectional)             Type of encoder RNN : bidirectional, bi-unidirectional, alternating (s2s)
--enc-cell arg (=gru)                       Type of RNN cell: gru, lstm, tanh (s2s)
--enc-cell-depth arg (=1)                   Number of tansitional cells in encoder layers (s2s)
--enc-depth arg (=1)                        Number of encoder layers (s2s)
--dec-cell arg (=gru)                       Type of RNN cell: gru, lstm, tanh (s2s)
--dec-cell-base-depth arg (=2)              Number of tansitional cells in first decoder layer (s2s)
--dec-cell-high-depth arg (=1)              Number of tansitional cells in next decoder layers (s2s)
--dec-depth arg (=1)                        Number of decoder layers (s2s)
--skip                                      Use skip connections (s2s)
--layer-normalization                       Enable layer normalization
--best-deep                                 Use Edinburgh deep RNN configuration (s2s)
--special-vocab arg                         Model-specific special vocabulary ids
--tied-embeddings                           Tie target embeddings and output embeddings in output layer
--tied-embeddings-src                       Tie source and target embeddings
--tied-embeddings-all                       Tie all embedding layers and output layer
--transformer-heads arg (=8)                Number of head in multi-head attention (transformer)
--transformer-dim-ffn arg (=2048)           Size of position-wise feed-forward network (transformer)
--transformer-preprocess arg                Operation before each transformer layer: d = dropout, a = add, n = normalize
--transformer-postprocess-emb arg (=d)      Operation after transformer embedding layer: d = dropout, a = add, n = normalize
--transformer-postprocess arg (=dan)        Operation after each transformer layer: d = dropout, a = add, n = normalize
--dropout-rnn arg (=0)                      Scaling dropout along rnn layers and time (0 = no dropout)
--dropout-src arg (=0)                      Dropout source words (0 = no dropout)
--dropout-trg arg (=0)                      Dropout target words (0 = no dropout)
--transformer-dropout arg (=0)              Dropout between transformer layers (0 = no dropout)
--transformer-dropout-attention arg (=0)    Dropout for transformer attention (0 = no dropout)
```

## Training options
```
--cost-type arg (=ce-mean)                  Optimization criterion: ce-mean, ce-mean-words, ce-sum, perplexity
--overwrite                                 Overwrite model with following checkpoints
--no-reload                                 Do not load existing model specified in --model arg
-t [ --train-sets ] arg                     Paths to training corpora: source target
-v [ --vocabs ] arg                         Paths to vocabulary files have to correspond to --train-sets. If this parameter is not supplied we look for vocabulary files 
                                            source.{yml,json} and target.{yml,json}. If these files do not exists they are created
--max-length arg (=50)                      Maximum length of a sentence in a training sentence pair
-e [ --after-epochs ] arg (=0)              Finish after this many epochs, 0 is infinity
--after-batches arg (=0)                    Finish after this many batch updates, 0 is infinity
--disp-freq arg (=1000)                     Display information every  arg  updates
--save-freq arg (=10000)                    Save model file every  arg  updates
--no-shuffle                                Skip shuffling of training data before each epoch
-T [ --tempdir ] arg (=/tmp)                Directory for temporary (shuffled) files
-d [ --devices ] arg (=0)                   GPUs to use for training. Asynchronous SGD is used with multiple devices
--mini-batch arg (=64)                      Size of mini-batch used during update
--mini-batch-words arg (=0)                 Set mini-batch size based on words instead of sentences
--mini-batch-fit                            Determine mini-batch size automatically based on sentence-length to fit reserved memory
--maxi-batch arg (=100)                     Number of batches to preload for length-based sorting
--maxi-batch-sort arg (=trg)                Sorting strategy for maxi-batch: trg (default) src none
-o [ --optimizer ] arg (=adam)              Optimization algorithm (possible values: sgd, adagrad, adam
--optimizer-params arg                      Parameters for optimization algorithm, e.g. betas for adam
--optimizer-delay arg (=1)                  SGD update delay, 1 = no delay
-l [ --learn-rate ] arg (=0.0001)           Learning rate
--lr-decay arg (=0)                         Decay factor for learning rate: lr = lr * arg (0 to disable)
--lr-decay-strategy arg (=epoch+stalled)    Strategy for learning rate decaying (possible values: epoch, batches, stalled, epoch+batches, epoch+stalled)
--lr-decay-start arg (=10 1)                The first number of epoch/batches/stalled validations to start learning rate decaying
--lr-decay-freq arg (=50000)                Learning rate decaying frequency for batches, requires --lr-decay-strategy to be batches
--lr-decay-reset-optimizer                  Reset running statistics of optimizer whenever learning rate decays
--lr-decay-repeat-warmup                    Repeat learning rate warmup when learning rate is decayed
--lr-decay-inv-sqrt arg (=0)                Decrease learning rate at arg / sqrt(no. updates) starting at arg
--lr-warmup arg (=0)                        Increase learning rate linearly for arg first steps
--lr-warmup-start-rate arg (=0)             Start value for learning rate warmup
--lr-warmup-cycle                           Apply cyclic warmup
--lr-warmup-at-reload                       Repeat warmup after interrupted training
--lr-report                                 Report learning rate for each update
--batch-flexible-lr                         Scales the learning rate based on the number of words in a mini-batch
--batch-normal-words arg (=1920)            Set number of words per batch that the learning rate corresponds to. The option is only active when batch-flexible-lr is on
--sync-sgd                                  Use synchronous SGD instead of asynchronous for multi-gpu training
--label-smoothing arg (=0)                  Epsilon for label smoothing (0 to disable)
--clip-norm arg (=1)                        Clip gradient norm to  arg  (0 to disable)
--exponential-smoothing [=arg(=1e-4)] (=0)  Maintain smoothed version of parameters for validation and saving with smoothing factor arg.  0 to disable.
--guided-alignment arg                      Use guided alignment to guide attention
--guided-alignment-cost arg (=ce)           Cost type for guided alignment. Possible values: ce (cross-entropy), mse (mean square error), mult (multiplication)
--guided-alignment-weight arg (=1)          Weight for guided alignment cost
--embedding-vectors arg                     Paths to files with custom source and target embedding vectors
--embedding-normalization                   Enable normalization of custom embedding vectors
--embedding-fix-src                         Fix source embeddings. Affects all encoders
--embedding-fix-trg                         Fix target embeddings. Affects all decoders
```

## Validation set options
```
--valid-sets arg                            Paths to validation corpora: source target
--valid-freq arg (=10000)                   Validate model every  arg  updates
--valid-metrics arg (=cross-entropy)        Metric to use during validation: cross-entropy, perplexity, valid-script, translation. Multiple metrics can be specified
--valid-mini-batch arg (=64)                Size of mini-batch used during validation
--valid-max-length arg (=1000)              Maximum length of a sentence in a validating sentence pair
--valid-script-path arg                     Path to external validation script. It should print a single score to stdout. If the option is used with validating translation, the 
                                            output translation file will be passed as a first argument 
--early-stopping arg (=10)                  Stop if the first validation metric does not improve for  arg  consecutive validation steps
--keep-best                                 Keep best model for each validation metric
--valid-log arg                             Log validation scores to file given by  arg
--valid-translation-output arg              Path to store the translation
--quiet-translation                         Suppress logging for validating translation
-b [ --beam-size ] arg (=12)                Beam size used during search with validating translator
-n [ --normalize ] [=arg(=1)] (=0)          Divide translation score by pow(translation length, arg) 
--allow-unk                                 Allow unknown words to appear in output
--n-best                                    Generate n-best list
```
Version: 
v1.0.0+83f3b35
