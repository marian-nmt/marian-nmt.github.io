---
layout: docs
title: Command-line options for marian-conv
permalink: /docs/cmd/marian-conv/
icon: fa-file-code-o
---

## marian-conv

Version: 
v1.9.1 95c65bb 2020-03-17 03:30:49 +0000

Usage: `marian/build/marian-conv [OPTIONS]`

### Allowed options
```
-h,--help                             Print this help message and exit
--version                             Print the version number and exit
-f,--from TEXT=model.npz              Input model
-t,--to TEXT=model.bin                Output model
-g,--gemm-type TEXT=float32           GEMM Type to be used: float32, packed16, packed8avx2, 
                                      packed8avx512
```

### Examples
```
./marian-conv -f model.npz -t model.bin --gemm-type packed16
```
