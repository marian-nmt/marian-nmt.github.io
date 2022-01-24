---
layout: docs
title: Command-line options
permalink: /docs/cmd/
icon: fa-file-code-o
---

## Tools

Click on the tool name below for a list of command line options.

The [amun]({% link docs/cmd/amun.md %}) tool offering CPU and GPU translation with specific
Marian and Nematus models, which used to be a part of Marian, has been moved to
its separate repository and is available from:
[https://github.com/marian-nmt/amun](https://github.com/marian-nmt/amun)


### Version {{ site.data.marian.version }}

Version:
{{ site.data.marian.version_full }}

- [marian]({% link docs/cmd/marian.md %}): training NMT models and language models.
- [marian-decoder]({% link docs/cmd/marian-decoder.md %}): CPU and GPU translation using NMT
  models trained with Marian.
- [marian-server]({% link docs/cmd/marian-server.md %}): a web-socket server providing
  translation service.
- [marian-scorer]({% link docs/cmd/marian-scorer.md %}): rescoring parallel text files and
  n-best lists.
- [marian-vocab]({% link docs/cmd/marian-vocab.md %}): creating a vocabulary from text given
  on STDIN.
- [marian-conv]({% link docs/cmd/marian-conv.md %}): converting a model into a binary
  format.


### Version 1.7.0

Version:
v1.7.0 67124f8 2018-11-28 13:04:30 +0000

- [marian]({% link docs/cmd/1.7.0/marian.md %}): for training NMT models and language models
- [marian-decoder]({% link docs/cmd/1.7.0/marian-decoder.md %}): for CPU and GPU translation using
  NMT models trained with Marian, and specific models trained with Nematus
- [marian-server]({% link docs/cmd/1.7.0/marian-server.md %}): a web-socket server providing
  translation service
- [marian-scorer]({% link docs/cmd/1.7.0/marian-scorer.md %}): for rescoring parallel text files
  and n-best lists
- [marian-vocab]({% link docs/cmd/1.7.0/marian-vocab.md %}): for creating a vocabulary from text
  given on STDIN
- [amun]({% link docs/cmd/amun.md %}): for CPU and GPU translation using specific models
  trained with Marian or Nematus
