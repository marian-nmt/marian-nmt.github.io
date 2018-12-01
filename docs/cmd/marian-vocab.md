---
layout: docs
title: Command-line options for marian-vocab
permalink: /docs/cmd/marian-vocab/
icon: fa-file-code-o
---

Usage: `./marian/build/marian-vocab [OPTIONS]`

## Allowed options
```
-h,--help                   Print this help message and exit
--version                   Print the version number and exit
-m,--max-size UINT=0        Generate only UINT most common vocabulary items
```

Examples:
```
./marian-vocab < text.src > vocab.yml
cat text.src text.trg | ./marian-vocab > vocab.yml
```
Version: 
v1.7.0 67124f8 2018-11-28 13:04:30 +0000
