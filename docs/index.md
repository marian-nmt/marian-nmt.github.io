---
layout: docs
title: Documentation
permalink: /docs/
icon: fa-file-code-o
menu: 3
---

For training NMT models, you want to use Marian toolkit. Amun provides fast
decoding for Marian's default models, which is compatible with Nematus/DL4MT
models.

## Code documentation

[The code documentation for Marian toolkit](/docs/marian/classes.html) is
generated using Doxygen. The newest version can be generated locally with CMake:
`mkdir -p build && cd build && cmake .. && make doc`.

## Marian command line options

Command-line options for `marian_train` tool:

### General options:
```
  -c [ --config ] arg                       Configuration file
  -w [ --workspace ] arg (=2048)            Preallocate  arg  MB of work space
  --log arg                                 Log training process information to file given by  arg
  --log-level arg (=info)                   Set verbosity level of logging (trace - debug - info - warn - err(or)
                                            - critical - off)
  --seed arg (=0)                           Seed for all random number generators. 0 means initialize randomly
  --relative-paths                          All paths are relative to the config file location
  --dump-config                             Dump current (modified) configuration to stdout and exit
  --version                                 Print version number and exit
  -h [ --help ]                             Print this help message and exit
```

### Model options:
```
  -m [ --model ] arg (=model.npz)           Path prefix for model to be saved/resumed
  --type arg (=amun)                        Model type (possible values: amun, s2s, multi-s2s)
  --dim-vocabs arg (=50000 50000)           Maximum items in vocabulary ordered by rank
  --dim-emb arg (=512)                      Size of embedding vector
  --dim-rnn arg (=1024)                     Size of rnn hidden state
  --enc-type arg (=bidirectional)           Type of encoder RNN : bidirectional, bi-unidirectional, alternating
                                            (s2s)
  --enc-cell arg (=gru)                     Type of RNN cell: gru, lstm, tanh (s2s)
  --enc-cell-depth arg (=1)                 Number of tansitional cells in encoder layers (s2s)
  --enc-depth arg (=1)                      Number of encoder layers (s2s)
  --dec-cell arg (=gru)                     Type of RNN cell: gru, lstm, tanh (s2s)
  --dec-cell-base-depth arg (=2)            Number of tansitional cells in first decoder layer (s2s)
  --dec-cell-high-depth arg (=1)            Number of tansitional cells in next decoder layers (s2s)
  --dec-depth arg (=1)                      Number of decoder layers (s2s)
  --skip                                    Use skip connections (s2s)
  --layer-normalization                     Enable layer normalization
  --best-deep                               Use WMT-2017-style deep configuration (s2s)
  --special-vocab arg                       Model-specific special vocabulary ids
  --tied-embeddings                         Tie target embeddings and output embeddings in output layer
  --dropout-rnn arg (=0)                    Scaling dropout along rnn layers and time (0 = no dropout)
  --dropout-src arg (=0)                    Dropout source words (0 = no dropout)
  --dropout-trg arg (=0)                    Dropout target words (0 = no dropout)
  --noise-src arg (=0)                      Add noise to source embeddings with given stddev (0 = no noise)
```
### Training options:
```
  --overwrite                               Overwrite model with following checkpoints
  --no-reload                               Do not load existing model specified in --model arg
  -t [ --train-sets ] arg                   Paths to training corpora: source target
  -v [ --vocabs ] arg                       Paths to vocabulary files have to correspond to --train-sets. If this
                                            parameter is not supplied we look for vocabulary files
                                            source.{yml,json} and target.{yml,json}. If these files do not exists
                                            they are created
  --max-length arg (=50)                    Maximum length of a sentence in a training sentence pair
  -e [ --after-epochs ] arg (=0)            Finish after this many epochs, 0 is infinity
  --after-batches arg (=0)                  Finish after this many batch updates, 0 is infinity
  --disp-freq arg (=1000)                   Display information every  arg  updates
  --save-freq arg (=10000)                  Save model file every  arg  updates
  --no-shuffle                              Skip shuffling of training data before each epoch
  -T [ --tempdir ] arg (=/tmp)              Directory for temporary (shuffled) files
  -d [ --devices ] arg (=0)                 GPUs to use for training. Asynchronous SGD is used with multiple devices
  --mini-batch arg (=64)                    Size of mini-batch used during update
  --mini-batch-words arg (=0)               Set mini-batch size based on words instead of sentences
  --dynamic-batching                        Determine mini-batch size dynamically based on sentence-length and
                                            reserved memory
  --maxi-batch arg (=100)                   Number of batches to preload for length-based sorting
  --maxi-batch-sort arg (=trg)              Sorting strategy for maxi-batch: trg (default) src none
  -o [ --optimizer ] arg (=adam)            Optimization algorithm (possible values: sgd, adagrad, adam
  -l [ --learn-rate ] arg (=0.0001)         Learning rate
  --lr-decay arg (=0)                       Decay factor for learning rate: lr = lr * arg (0 to disable)
  --lr-decay-strategy arg (=epoch+stalled)  Strategy for learning rate decaying (possible values: epoch, batches,
                                            stalled, epoch+batches, epoch+stalled)
  --lr-decay-start arg (=10,1)              The first number of epoch/batches/stalled validations to start learning
                                            rate decaying
  --lr-decay-freq arg (=50000)              Learning rate decaying frequency for batches, requires
                                            --lr-decay-strategy to be batches
  --clip-norm arg (=1)                      Clip gradient norm to  arg  (0 to disable)
  --moving-average                          Maintain and save moving average of parameters
  --moving-decay arg (=0.9999)              Decay factor for moving average
  --guided-alignment arg                    Use guided alignment to guide attention
  --guided-alignment-cost arg (=ce)         Cost type for guided alignment. Possible values: ce (cross-entropy), mse
                                            (mean square error), mult (multiplication)
  --guided-alignment-weight arg (=1)        Weight for guided alignment cost
  --drop-rate arg (=0)                      Gradient drop ratio (read: https://arxiv.org/abs/1704.05021)
  --embedding-vectors arg                   Paths to files with custom source and target embedding vectors
  --embedding-normalization                 Enable normalization of custom embedding vectors
  --embedding-fix-src                       Fix source embeddings. Affects all encoders
  --embedding-fix-trg                       Fix target embeddings. Affects all decoders
```

### Validation set options:
```
  --valid-sets arg                          Paths to validation corpora: source target
  --valid-freq arg (=10000)                 Validate model every  arg  updates
  --valid-metrics arg (=cross-entropy)      Metric to use during validation: cross-entropy, perplexity,
                                            valid-script. Multiple metrics can be specified
  --valid-mini-batch arg (=64)              Size of mini-batch used during validation
  --valid-script-path arg                   Path to external validation script
  --early-stopping arg (=10)                Stop if the first validation metric does not improve for  arg
                                            consecutive validation steps
  --keep-best                               Keep best model for each validation metric
  --valid-log arg                           Log validation scores to file given by  arg
```

## Amun command line options

Command-line options for `amun` decoder:

### General options

```
  -c [ --config ] arg             Configuration file
  -i [ --input-file ] arg         Take input from a file instead of stdin
  -m [ --model ] arg              Overwrite scorer section in config file with these models. Assumes models of
                                  type Nematus and assigns model names F0, F1, ...
  -s [ --source-vocab ] arg       Overwrite source vocab section in config file with vocab file.
  -t [ --target-vocab ] arg       Overwrite target vocab section in config file with vocab file.
  --bpe arg                       Overwrite bpe section in config with bpe code file.
  --no-debpe                      Providing bpe is on, turn off deBPE of the output.
  -d [ --devices ] arg (=0)       CUDA device(s) to use, set to 0 by default, e.g. set to 0 1 to use gpu0
                                  and gpu1. Implicitly sets minimal number of threads to number of devices.
  --gpu-threads arg (=1)          Number of threads on a single GPU.
  --cpu-threads arg (=0)          Number of threads on the CPU.
  --mini-batch arg (=1)           Number of sentences in mini batch.
  --maxi-batch arg (=1)           Number of sentences in maxi batch.
  --show-weights                  Output used weights to stdout and exit
  --load-weights arg              Load scorer weights from this file
  --wipo                          Use WIPO specific n-best-list format and non-buffering single-threading
  --return-alignment              If true, return alignment.
  --max-length arg (=500)         Maximum length of input sentences. Anything above is truncated. 0=no max length
  -v [ --version ]                Print version.
  -h [ --help ]                   Print this help message and exit
  --log-progress [=arg(=1)] (=1)  Log progress to stderr.
  --log-info [=arg(=1)] (=1)      Log info to stderr.
```

### Search options

```
  -b [ --beam-size ] arg (=12)    Decoding beam-size
  -n [ --normalize ]              Normalize scores by translation length after decoding
  -f [ --softmax-filter ] arg     Filter final softmax: path to file with alignment [N first words]
  -u [ --allow-unk ]              Allow generation of UNK
  --n-best                        Output n-best list with n = beam-size
```

### Configuration meta options

```
  --relative-paths                All paths are relative to the config file location
  --dump-config                   Dump current (modified) configuration to stdout and exit
```
