---
layout: docs
title: Command-line options for marian-conv
permalink: /docs/cmd/1.7.0/marian-conv/
icon: fa-file-code-o
---

## marian-conv
Version: 
v1.7.0 67124f8 2018-11-28 13:04:30 +0000

Usage: `./marian/build/marian-conv [OPTIONS]`

### Allowed options
```
-h,--help                   Print this help message and exit
--version                   Print the version number and exit
-f,--from TEXT=model.npz    Input model
-t,--to TEXT=model.bin      Output model
```

### Examples
```
./marian-conv -f model.npz -t model.bin
```

