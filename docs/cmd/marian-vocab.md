---
layout: docs
title: Command-line options for marian-vocab
permalink: /docs/cmd/marian-vocab/
icon: fa-file-code-o
---

## marian-vocab

Version: 
v1.10.3 8f73923 2021-03-18 03:34:44 +0000

Usage: `./marian-vocab [OPTIONS]`

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
