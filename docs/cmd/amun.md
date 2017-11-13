---
layout: docs
title: Command-line options for amun
permalink: /docs/cmd/amun/
icon: fa-file-code-o
---


## General options
```
-c [ --config ] arg                   Configuration file
-i [ --input-file ] arg               Take input from a file instead of stdin
-m [ --model ] arg                    Overwrite scorer section in config file
                                      with these models. Assumes models of
                                      type Nematus and assigns model names
                                      F0, F1, ...
-s [ --source-vocab ] arg             Overwrite source vocab section in
                                      config file with vocab file.
-t [ --target-vocab ] arg             Overwrite target vocab section in
                                      config file with vocab file.
--bpe arg                             Overwrite bpe section in config with
                                      bpe code file.
--no-debpe                            Providing bpe is on, turn off deBPE of
                                      the output.
-d [ --devices ] arg (=0)             CUDA device(s) to use, set to 0 by
                                      default, e.g. set to 0 1 to use gpu0
                                      and gpu1. Implicitly sets minimal
                                      number of threads to number of devices.
--gpu-threads arg (=1)                Number of threads on a single GPU.
--cpu-threads arg (=0)                Number of threads on the CPU.
--mini-batch arg (=1)                 Number of sentences in mini batch.
--maxi-batch arg (=1)                 Number of sentences in maxi batch.
--mini-batch-words arg (=0)           Set mini-batch size based on words
                                      instead of sentences.
--show-weights                        Output used weights to stdout and exit
--load-weights arg                    Load scorer weights from this file
--wipo                                Use WIPO specific n-best-list format
                                      and non-buffering single-threading
--return-alignment                    If true, return alignment.
--return-soft-alignment               If true, return soft alignment.
--return-nematus-alignment            If true, return Nematus style soft
                                      alignment.
--max-length arg (=500)               Maximum length of input sentences.
                                      Anything above this is truncated. 0=no
                                      max length
-v [ --version ]                      Print version.
-h [ --help ]                         Print this help message and exit
--log-progress [=arg(=info)] (=info)  Log level for progress logging to
                                      stderr (trace - debug - info - warn -
                                      err(or) - critical - off).
--log-info [=arg(=info)] (=info)      Log level for informative messages to
                                      stderr (trace - debug - info - warn -
                                      err(or) - critical - off).
```

## Search options
```
-b [ --beam-size ] arg (=12)          Decoding beam-size
-n [ --normalize ]                    Normalize scores by translation length
                                      after decoding
-f [ --softmax-filter ] arg           Filter final softmax: path to file with
                                      alignment [N first words]
-u [ --allow-unk ]                    Allow generation of UNK
--n-best                              Output n-best list with n = beam-size
```

## Configuration meta options
```
--relative-paths                      All paths are relative to the config
                                      file location
--dump-config                         Dump current (modified) configuration
                                      to stdout and exit
```
