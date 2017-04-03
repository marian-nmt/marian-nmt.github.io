---
layout: docs
title: Documentation
permalink: /docs/
icon: fa-file-code-o
menu: 3
---

## Marian (Training)

### General options

```
  -c [ --config ] arg                   Configuration file
  -w [ --workspace ] arg (=2048)        Preallocate  arg  MB of work space
  --log arg                             Log training process information to 
                                        file given by  arg
  --seed arg (=0)                       Seed for all random number generators. 
                                        0 means initialize randomly
  --relative-paths                      All paths are relative to the config 
                                        file location
  --dump-config                         Dump current (modified) configuration 
                                        to stdout and exit
  -h [ --help ]                         Print this help message and exit
```

### Model options

```
  -m [ --model ] arg (=model.npz)       Path prefix for model to be 
                                        saved/resumed
  --type arg (=dl4mt)                   Model type (possible values: dl4mt, 
                                        gnmt, multi-gnmt
  --dim-vocabs arg (=50000 50000)       Maximum items in vocabulary ordered by 
                                        rank
  --dim-emb arg (=512)                  Size of embedding vector
  --dim-rnn arg (=1024)                 Size of rnn hidden state
  --layers-enc arg (=1)                 Number of encoder layers
  --layers-dec arg (=1)                 Number of decoder layers
  --skip                                Use skip connections
  --layer-normalization                 Enable layer normalization
  --dropout-rnn arg (=0)                Scaling dropout along rnn layers and 
                                        time (0 = no dropout)
  --dropout-src arg (=0)                Dropout source words (0 = no dropout)
  --dropout-trg arg (=0)                Dropout target words (0 = no dropout)
```


### Training options

```
  --overwrite                           Overwrite model with following 
                                        checkpoints
  --no-reload                           Do not load existing model specified in
                                        --model arg
  -t [ --train-sets ] arg               Paths to training corpora: source 
                                        target
  -v [ --vocabs ] arg                   Paths to vocabulary files have to 
                                        correspond to --trainsets. If this 
                                        parameter is not supplied we look for 
                                        vocabulary files source.{yml,json} and 
                                        target.{yml,json}. If these files do 
                                        not exists they are created.
  --max-length arg (=50)                Maximum length of a sentence in a 
                                        training sentence pair
  -e [ --after-epochs ] arg (=0)        Finish after this many epochs, 0 is 
                                        infinity
  --after-batches arg (=0)              Finish after this many batch updates, 0
                                        is infinity
  --disp-freq arg (=1000)               Display information every  arg  updates
  --save-freq arg (=10000)              Save model file every  arg  updates
  --no-shuffle                          Skip shuffling of training data before 
                                        each epoch
  -d [ --devices ] arg (=0)             GPUs to use for training. Asynchronous 
                                        SGD is used with multiple devices.
  --mini-batch arg (=64)                Size of mini-batch used during update
  --maxi-batch arg (=100)               Number of batches to preload for 
                                        length-based sorting
  -o [ --optimizer ] arg (=adam)        Optimization algorithm (possible 
                                        values: sgd, adagrad, adam
  -l [ --learn-rate ] arg (=0.0001)     Learning rate
  --clip-norm arg (=1)                  Clip gradient norm to  arg  (0 to 
                                        disable)
  --moving-average                      Maintain and save moving average of 
                                        parameters
  --moving-decay arg (=0.999)           decay factor for moving average
```

### Validation set options

```
  --valid-sets arg                      Paths to validation corpora: source 
                                        target
  --valid-freq arg (=10000)             Validate model every  arg  updates
  --valid-metrics arg (=cross-entropy)  Metric to use during validation: 
                                        cross-entropy, perplexity, 
                                        valid-script. Multiple metrics can be 
                                        specified
  --valid-script-path arg               Path to external validation script
  --early-stopping arg (=10)            Stop if the first validation metric 
                                        does not improve for  arg  consecutive 
                                        validation steps
  --valid-log arg                       Log validation scores to file given by 
                                        arg
```

## Amun (Translation)

### General options

```
  -c [ --config ] arg             Configuration file
  -i [ --input-file ] arg         Take input from a file instead of stdin
  -m [ --model ] arg              Overwrite scorer section in config file with 
                                  these models. Assumes models of type Nematus 
                                  and assigns model names F0, F1, ...
  -s [ --source-vocab ] arg       Overwrite source vocab section in config file
                                  with vocab file.
  -t [ --target-vocab ] arg       Overwrite target vocab section in config file
                                  with vocab file.
  --bpe arg                       Overwrite bpe section in config with bpe code
                                  file.
  --no-debpe                      Providing bpe is on, turn off deBPE of the 
                                  output.
  -d [ --devices ] arg (=0)       CUDA device(s) to use, set to 0 by default, 
                                  e.g. set to 0 1 to use gpu0 and gpu1. 
                                  Implicitly sets minimal number of threads to 
                                  number of devices.
  --gpu-threads arg (=1)          Number of threads on a single GPU.
  --cpu-threads arg (=0)          Number of threads on the CPU.
  --mini-batch arg (=1)           Number of sentences in mini batch.
  --maxi-batch arg (=1)           Number of sentences in maxi batch.
  --show-weights                  Output used weights to stdout and exit
  --load-weights arg              Load scorer weights from this file
  --wipo                          Use WIPO specific n-best-list format and 
                                  non-buffering single-threading
  --return-alignment              If true, return alignment.
  --max-length arg (=500)         Maximum length of input sentences. Anything 
                                  above this is truncated. 0=no max length
  -v [ --version ]                Print version.
  -h [ --help ]                   Print this help message and exit
  --log-progress [=arg(=1)] (=1)  Log progress to stderr.
  --log-info [=arg(=1)] (=1)      Log info to stderr.
```

### Search options

```
  -b [ --beam-size ] arg (=12)    Decoding beam-size
  -n [ --normalize ]              Normalize scores by translation length after 
                                  decoding
  -f [ --softmax-filter ] arg     Filter final softmax: path to file with 
                                  alignment [N first words]
  -u [ --allow-unk ]              Allow generation of UNK
  --n-best                        Output n-best list with n = beam-size
```

### Configuration meta options

```
  --relative-paths                All paths are relative to the config file 
                                  location
  --dump-config                   Dump current (modified) configuration to 
                                  stdout and exit
```