---
layout: docs
title: Command-line options for marian-vocab
permalink: /docs/cmd/marian-vocab/
icon: fa-file-code-o
---

## marian-vocab

Version: 
v1.9.1 95c65bb 2020-03-17 03:30:49 +0000

Usage: `marian/build/marian-vocab [OPTIONS]`

### Allowed options
```
-h,--help                             Print this help message and exit
--version                             Print the version number and exit
-m,--max-size UINT=0                  Generate only UINT most common vocabulary items
```

### Examples
```
./marian-vocab < text.src > vocab.yml
cat text.src text.trg | ./marian-vocab > vocab.yml
```
