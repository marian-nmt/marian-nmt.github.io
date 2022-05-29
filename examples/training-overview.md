---
layout: docs
title: Training with Marian
permalink: /examples/training-overview
icon: fa-cogs
---

This tutorial serves as a guide for beginners in neural machine translation
(NMT). It should allow you to appreciate the motivation behind the different
steps taken in the other examples and tutorials.

We'll explore a simplified pipeline to produce a translation model consisting
of:
  1. Data acquisition
  2. Data preparation
  3. Training
  4. Evaluation

## Data acquisition
Central to producing a machine translation system is the data used to train it.
The models rely on large amounts of quality data to perform well. One aspect of
this quality is whether your chosen dataset is suited to your desired
translation task.

Training data takes the form of equivalent text sequences in the source-language
and target-language. You can find examples of such corpora compiled at [ELRC],
[ParaCrawl] and [OPUS], as well as others. These parallel corpora may be found
stored in different formats. Common formats include: TMX, TSV and plain text.

Translation Memory eXchange, or [TMX], is an XML formatted standard that encodes
parallel data in terms of translation units. A translation unit is a set of
aligned sentences across multiple languages. Each variant in the set consists of
sentence in a particular language. A minimal translation unit that containing
English "_Hello world!_" and the Italian "_Ciao mondo!_" would look like
```xml
...
<tu>
  <tuv xml:lang="en">
    <seg>Hello world!</seg>
  </tuv>
  <tuv xml:lang="it">
    <seg>Ciao mondo!</seg>
  </tuv>
</tu>
...
```
and be stored alongside other units in the full TMX file. The complete file may
contain additional metadata, such as the origin of each segment or a confidence
score for the variants.

TSV and plain text files are somewhat simpler. They maintain association between
parallel sentences by aligning them line-by-line. In the case of a tab-separated
values (TSV) file the parallel segments from each language are contained on the
same line in one file, with each language separated by a tab character, such as:
```shell
# $ cat corpus.en-it.tsv
Hello world!	Ciao mondo!
```
Plain text files store associated sentences in different files, one for each
language, such that the sentence on a line of one file is parallel to the
sentence on the same line in another file. As in:

```shell
# $ cat corpus.en.txt
Hello world!

# $ cat corpus.it.txt
Ciao mondo!
```

Marian natively accepts TSV and plain-text files. For TMX files, you can extract
TSV or plain text files using external tools. In the remainder of this example,
we'll consider a pair of plain-text files.

## Data preparation
Having obtained a dataset for the languages you want to translate between, there
are several preprocessing steps that can impact the quality of the final model.

### Cleaning

The first step concerns the quality of the dataset, and filtering out noise
present in it. In terms of parallel text data, this noise can be in the form of
poor alignment, which results in the incorrect pairing of sentence. Similarly,
non-translated source-side sentences may be present on the target-side, or the
target-side may be a valid translation but in the wrong language. Inconsistent
spelling and punctuation are an additional source of noise. In an attempt to
address noise in the data, rule-based cleaning is applied to the data.

Rule-based cleaning is a set of heuristics applied to the corpus to remove low
quality data. As an example, such rules may impose limits on:
  - the minimum and maximum length of segments
  - the ratio between the source and target lengths.
  - the ratio between alphabet to non-alphabet characters
  - the ratio between alphabet to non-alphabet words
  - the result of a model-based language classifier

Deduplication is also commonly applied as part of corpus cleaning.

These rules are motivated from the desire to remove overly long segments that
may consist of multiple sentences, with the added benefit that this can reduce
the memory required in training; this also includes the removal of empty
sentences. The ratio on lengths codifies the idea that the length of the source
and target sentences should be positively correlated. The content of the
segments can also checked by restricting the presence of non-alphabet
characters/words for the language in question. In doing so, we are able to
remove sentences consisting of few real words, and sentences with too many
characters from a different alphabet. These act as a quick language filter.
However, a dedicated filter based on the result of language classification model
is a stronger requirement.

Automatic cleaning methods can also be utilised. One such example is filtering
based on the [dual conditional cross-entropy][dcce]. By training two rudimentary
translation models, one in the desired direction and the other in the reverse,
this combined metric scores sentence pairs based the level of agreement between
the models with a penalty for sentence pair that both models deem improbable.

Normalisation is may also be applied a pre-processing step. An example of
normalisation would be the localisation of punctuation, such as the style of
quotation marks, or the radix character
```
The number is 3.14  # en
Il numero è 3,14    # it
```

The normalisation of capitalisation, known as Truecasing (see e.g. [truecaser] from [Moses]), can also be applied. This method attempts to
reconstruct the proper capitalisation for words in the sentence. These casing
rules may differ between the source and target language.

As is the case with heuristically motivated techniques, the choice of rules
imposed and reasonable values for their thresholds will depend on the languages
involved and the domain of interest.

### Tokenisation
Tokenisation is the process of splitting up text into smaller fragments called
tokens. These tokens are associated with some numeric representation, such as an
ID, that allows them be used in a machine translation model. The vocabulary is
the set of tokens extracted from the corpus, with the number of tokens setting
the vocabulary size. Unfortunately, the complexity of training and translating
increases with vocabulary size. This leads to a trade

A simple approach is to perform word tokenization, in which each word in the
sentence becomes its own token. However, the size of the vocabulary grows with
each new word, even if the new word is related to an existing one. The words
`grow`, `grows` and `growing` would all get distinct tokens despite sharing a
common stem in `grow`. To better handle this we can look at subword units to
model these relationships. We may imagine in the previous example, that our
subword tokens would be `▁grow`, `s` and `ing`, where `▁` represents the
beginning of a word. From this we can reconstruct the three example words:
`▁grow`, `▁grow s` and `▁grow ing`, but may also generalise to new words
`▁grown` and `▁grow th`. One approach to discovering these subword
representations is Byte-Pair Encoding, or BPE. This procedure looks through the
corpus starting at the character level and successively joins the most frequent
pairs of symbols until the desired vocabulary size is achieved. Imagining back
to the example, the BPE algorithm would likely see the co-occurrence of `i` and
`n`, and later the co-occurrence of `in` and `g` to form `ing` as a token. There
are extensions to this idea that take a probabilistic approach to determining
what subwords to build, and even in determining how a particular sentence should
be encoded.

In Marian tutorials and examples we make use of the [Moses][moses]
[tokenizer][tokenizer] script and BPE. Additionally, we show examples using
[SentencePiece] models that are natively supported. While, another commonly used
implementation is [subword-nmt].


## Training
In many aspects, the process of training a machine translation model is no
different than training machine learning systems in other domains. The process
starts with the acquisition and preparation of datasets, as described above. We
must then select a model type suited to our particular task. For machine
translation in Marian, this might be an RNN encoder-decoder (s2s) model or a
transformer model. The model type sets the general network architecture, but
does not uniquely define it. The size of the network and vocabulary as well as a
the choice of training parameters: loss function, optimizer, learning rate
schedule and validation metrics, are all important considerations.

### Model Architecture
There are additional hyperparameters that control model behaviour. The size of
the embedding dimension is an integral part of the model; it directly sets the
size of its internal representation. The mapping from tokens to this internal
representation requires a matrix containing a vector representation for each
token in the vocabulary. A typical vocabulary size of `32000` and an embedding
dimension of `512` requires over 16 million parameters. In general, an separate
embedding matrix is required to map source-side tokens to vectors, target-side
tokens to vectors, and output vectors to target-side tokens. In practice, the
latter two matrices can share the same parameters in a process known as weight
tying. When translating between languages that use the same script its practical
to tie all of the embeddings.

The complexity of the model is also affected by its depth. Marian has separate
controls for the depth of the encoder and decoder. Concisely, these control the
number of layers of computation with the motivation being that additional layers
give the model the capacity to learn more efficient representations. Beyond the
number of layers, there are hyperparameters that modify the behaviour of the
layers themselves. These range from modifying activation functions, specifying
the gating mechanism in RNN cells as well as the intermediate dimensions in
feed-forward blocks.

### Loss functions and optimizers
The learning process of the machine learning model is guided by the loss
function and the optimizer. The loss function is a function that quantifies the
"distance" between the current output and the desired output. It may also be
referred to as the cost function, as it is in Marian. The cross-entropy loss is
the default cost in Marian.

The optimizer codifies the procedure in which the model moves towards the
desired solution. These typically use gradients, computed by the network, to
update the parameters in a direction that steps towards a minimum. The size of
these steps is mediated by the learning-rate hyper-parameter. At its simplest,
the learning-rate is just a fixed quantity, but more advanced schemes can vary
the value over time, a so-called learning rate schedule, depending on factors
such as amount of data seen, or updates without cost improvement. The inclusion
of an initial warmup phase at the start of training is often recommended to
stabilise updates.

Beyond this overall rate, different optimization algorithms may employ their own
parameters. For instance, the Adam optimization algorithm also computes an
separate exponentially decaying average for the first and second moments of
parameter gradients; the rate of each exponential decay are user configurable.



### Training and validation
During training, the machine translation model processes the parallel corpus.
The source input is propagated through the network architecture and compared to
the target sentence. The loss is computed, and the optimizer determines the
update applied to the models parameters.

For any reasonably sized dataset, memory constraints mean it is not possible to
process the entire corpus in a single batch. Instead, the corpus is processed as
a sequence of mini-batches, whose size is constrained by the number of
sentences, or tokens it contains. In Marian, either of these options may be
controlled directly, or alternatively, the mini-batch size can be determined
automatically by the workspace memory allocated to the program. Marian also has
the concept of a _maxi batch_ which preloads multiple mini-batches. This
preloading makes it possible to sort sentences within the maxi batch to
regenerate mini-batches that have similar sentence lengths. Constructing
mini-batches in this way can reduce the number of padding tokens required
increasing the computational efficiency.

This training process repeats until some stopping criteria is met. A practical
criterion is to stop training after a certain amount of data has been seen; this
may be in terms of batches, tokens, or epochs, the number of times the model has
seen the entire dataset. However, this tells us nothing of the resulting models
quality. While the cost does give an indication of model performance, it is
biased by having already seen the data. The solution to this is to periodically
validate the performance of the model against an unseen dataset, or validation
set. Computing a metric from this independent dataset enables one to halt
training before the model is overfit to the training data. A common approach
used in Marian is early-stopping, where training concludes after successive
validation scores fail to improve over some period. As an example, an
early-stopping value of `5` would stop training if the previous five updates did
not yield an improved validation score.

To monitor your model during training, Marian will periodically output a summary
of its progress. A typical output is shown below.
```log
Ep. 7 : Up. 36000 : Sen. 948,710 : Cost 3.21035433 : Time 317.61s : 77198.20 words/s : gNorm 0.5012
```
Here `Ep.` refers to the number of epochs and `Up.` to the total number of
optimizer updates. `Sen.` is the number of sentences seen this epoch. `Cost` is
the current value of the loss function. `Time` is the time taken to process the
last batch of data, and is followed by the processing speed in words per second.
Finally, `gNorm` reports the exponential average for the norms of parameter
gradients. Similarly, the validator will periodically compute and output its
score, such as in
```log
[valid] Ep. 9 : Up. 50000 : bleu : 35.9958 : stalled 2 times (last best: 36.0671)
[valid] Ep. 9 : Up. 50000 : perplexity : 3.74923 : new best
```
which shows the result of two different validators. They report that after
update `50000`, which occurs in data epoch `9`, the `bleu` validator has a score
of `35.9958` having stalled twice, while the `perplexity` score has improved to
`3.74923`. Marian supports a number of validation metrics while also providing
an option to use a custom validator script.

## Evaluation
The evaluation of a machine translation model measures the quality of its
output. The final evaluation of a model is made using a test set. This test set
should be independent to the training set and also to the validation set, as it
is no longer unbiased, having been used to select an optimal set of
hyperparameters. It is crucial that any pre-processing (normalisation) that was
applied to the training data is applied identically for evaluation.

The natural benchmark to gauge quality is human judgement in
which participants score the translated output of a test set given the source
input, sometimes with the context of a reference translation. In practice
undertaking a statistically robust human assessment is costly, and is only
feasible to compare small sets of models.

Automatic evaluation metrics are therefore a desired alternative, provided they
reliably correlate with human judgement while also being practical to deploy at
scale. Automated metrics are often used in model validation and evaluation. For
instance, the validator example of the previous section contains a BLEU score.

The [BLEU] score is a widely used algorithm, it computes a metric based on a
modified precision score over n-grams (a contiguous sequence of `n` words) in
the candidate translation as compared to a reference. It also includes a
"brevity penalty" to prevent candidates much shorter than their references being
too highly scored. An alternate n-gram based metric is chrF, which computes a
character-based n-gram F-score. Another approach is taken by the translation
error rate (TER) which measures the number of corrections required to match the
reference. Each of these implicitly relies on a tokenization method, and so to
compare across models in a consistent manner this should be standardized. Tools
like [sacrebleu] exist to consistently compare these metrics. In contrast to
these rule-based metrics, it is also possible to build a model to predict the
human judgement for a particular source, candidate and reference sentence. An
example of such a tool is [Comet], which provides pre-trained multilingual
scoring models.

Beyond an evaluation of the overall translation quality, the performance against
specific tasks can also be considered. Typically, a metric is computed on a
challenge set with a focus on a linguistically motivated feature such as
negation, punctuation, grammatical gender or verb tense; see [ContraPro] for
such an example. Further measurements may focus on detecting biases present in
models. Taken together these offer a more compelling report of the capability
and deficiencies of a particular model.


Hopefully this guide serves as solid foundation as you explore the other
tutorials and examples related to Marian!

<!-- Links -->
[elrc]: https://www.elrc-share.eu/
[opus]: https://opus.nlpl.eu/
[paracrawl]: https://paracrawl.eu/

[tmx]: https://en.wikipedia.org/wiki/Translation_Memory_eXchange

[dcce]: https://aclanthology.org/W18-6478v2.pdf

[moses]: https://github.com/moses-smt/mosesdecoder/
[tokenizer]: https://github.com/marian-nmt/moses-scripts/blob/master/scripts/tokenizer/tokenizer.perl
[truecaser]: https://github.com/marian-nmt/moses-scripts/tree/master/scripts/recaser
[sentencepiece]: https://github.com/google/sentencepiece
[subword-nmt]: https://github.com/rsennrich/subword-nmt

[bleu]: https://en.wikipedia.org/wiki/BLEU
[sacrebleu]: https://github.com/mjpost/sacrebleu
[comet]: https://github.com/Unbabel/COMET

[contrapro]: https://github.com/ZurichNLP/ContraPro
