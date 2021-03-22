---
layout: docs
title: Command-line options for marian-server
permalink: /docs/cmd/marian-server/
icon: fa-file-code-o
---

## marian-server

Version: 
v1.10.3 8f73923 2021-03-18 03:34:44 +0000

Usage: `./marian-server [OPTIONS]`

### General options
```
-h,--help                             Print this help message and exit
--version                             Print the version number and exit
--authors                             Print list of authors and exit
--cite                                Print citation and exit
--build-info TEXT                     Print CMake build options and exit. Set to 'all' to print 
                                      advanced options
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
--check-nan                           Check for NaNs or Infs in forward and backward pass. Will 
                                      abort when found. This is a diagnostic option that will 
                                      slow down computation significantly
--interpolate-env-vars                allow the use of environment variables in paths, of the form 
                                      ${VAR_NAME}
--relative-paths                      All paths are relative to the config file location
--dump-config TEXT                    Dump current (modified) configuration to stdout and exit. 
                                      Possible values: full, minimal, expand
```

### Server options
```
-p,--port UINT=8080                   Port number for web socket server
```

### Model options
```
-m,--models VECTOR ...                Paths to model(s) to be loaded. Supported file extensions: 
                                      .npz, .bin
--ignore-model-config                 Ignore the model configuration saved in npz file
--type TEXT=amun                      Model type: amun, nematus, s2s, multi-s2s, transformer
--dim-vocabs VECTOR=0,0 ...           Maximum items in vocabulary ordered by rank, 0 uses all 
                                      items in the provided/created vocabulary file
--dim-emb INT=512                     Size of embedding vector
--lemma-dim-emb INT=0                 Re-embedding dimension of lemma in factors
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
--input-types VECTOR ...              Provide type of input data if different than 'sequence'. 
                                      Possible values: sequence, class, alignment, weight. You 
                                      need to provide one type per input file (if --train-sets) 
                                      or per TSV field (if --tsv).
--best-deep                           Use Edinburgh deep RNN configuration (s2s)
--tied-embeddings                     Tie target embeddings and output embeddings in output layer
--tied-embeddings-src                 Tie source and target embeddings
--tied-embeddings-all                 Tie all embedding layers and output layer
--output-omit-bias                    Do not use a bias vector in decoder output layer
--transformer-heads INT=8             Number of heads in multi-head attention (transformer)
--transformer-no-projection           Omit linear projection after multi-head attention 
                                      (transformer)
--transformer-pool                    Pool encoder states instead of using cross attention 
                                      (selects first encoder state, best used with special token)
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
--transformer-postprocess-top TEXT    Final operation after a full transformer stack: d = dropout, 
                                      a = add, n = normalize. The optional skip connection with 
                                      'a' by-passes the entire stack.
--transformer-train-position-embeddings
                                      Train positional embeddings instead of using static 
                                      sinusoidal embeddings
--transformer-depth-scaling           Scale down weight initialization in transformer layers by 1 
                                      / sqrt(depth)
--bert-mask-symbol TEXT=[MASK]        Masking symbol for BERT masked-LM training
--bert-sep-symbol TEXT=[SEP]          Sentence separator symbol for BERT next sentence prediction 
                                      training
--bert-class-symbol TEXT=[CLS]        Class symbol BERT classifier training
--bert-masking-fraction FLOAT=0.15    Fraction of masked out tokens during training
--bert-train-type-embeddings=true     Train bert type embeddings, set to false to use static 
                                      sinusoidal embeddings
--bert-type-vocab-size INT=2          Size of BERT type vocab (sentence A and B)
```

### Translator options
```
-i,--input VECTOR=stdin ...           Paths to input file(s), stdin by default
-o,--output TEXT=stdout               Path to output file, stdout by default
-v,--vocabs VECTOR ...                Paths to vocabulary files have to correspond to --input
-b,--beam-size UINT=12                Beam size used during search with validating translator
-n,--normalize FLOAT=0                Divide translation score by pow(translation length, arg)
--max-length-factor FLOAT=3           Maximum target length as source length times factor
--word-penalty FLOAT                  Subtract (arg * translation length) from translation score
--allow-unk                           Allow unknown words to appear in output
--n-best                              Generate n-best list
--alignment TEXT                      Return word alignment. Possible values: 0.0-1.0, hard, soft
--word-scores                         Print word-level scores. One score per subword unit, not 
                                      normalized even if --normalize
--no-spm-decode                       Keep the output segmented into SentencePiece subwords
--max-length UINT=1000                Maximum length of a sentence in a training sentence pair
--max-length-crop                     Crop a sentence to max-length instead of omitting it if 
                                      longer than max-length
--tsv                                 Tab-separated input
--tsv-fields UINT                     Number of fields in the TSV input. By default, it is guessed 
                                      based on the model type
-d,--devices VECTOR=0 ...             Specifies GPU ID(s) to use for training. Defaults to 
                                      0..num-devices-1
--num-devices UINT                    Number of GPUs to use for this process. Defaults to 
                                      length(devices) or 1
--cpu-threads UINT=0                  Use CPU-based computation with this many independent 
                                      threads, 0 means GPU-based computation
--mini-batch INT=1                    Size of mini-batch used during batched translation
--mini-batch-words INT                Set mini-batch size based on words instead of sentences
--maxi-batch INT=1                    Number of batches to preload for length-based sorting
--maxi-batch-sort TEXT=none           Sorting strategy for maxi-batch: none, src, trg (not 
                                      available for decoder)
--fp16                                Shortcut for mixed precision inference with float16, 
                                      corresponds to: --precision float16
--precision VECTOR=float32 ...        Mixed precision for inference, set parameter type in 
                                      expression graph
--skip-cost                           Ignore model cost during translation, not recommended for 
                                      beam-size > 1
--shortlist VECTOR ...                Use softmax shortlist: path first best prune
--weights VECTOR ...                  Scorer weights
--output-sampling=false               Noise output layer with gumbel noise
--output-approx-knn VECTOR ...        Use approximate knn search in output layer (currently only 
                                      in transformer)
```
