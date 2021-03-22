---
layout: docs
title: Command-line options for marian-conv
permalink: /docs/cmd/marian-conv/
icon: fa-file-code-o
---

## marian-conv

Version: 
v1.10.3 8f73923 2021-03-18 03:34:44 +0000

Usage: `./marian-conv [OPTIONS]`

### Allowed options
```
-h,--help                             Print this help message and exit
--version                             Print the version number and exit
-f,--from TEXT=model.npz              Input model
-t,--to TEXT=model.bin                Output model
--export-as TEXT=marian-bin           Kind of conversion: marian-bin or 
                                      onnx-{encode,decoder-step,decoder-init,decoder-stop}
-g,--gemm-type TEXT=float32           GEMM Type to be used: float32, packed16, packed8avx2, 
                                      packed8avx512, intgemm8, intgemm8ssse3, intgemm8avx2, 
                                      intgemm8avx512, intgemm16, intgemm16sse2, intgemm16avx2, 
                                      intgemm16avx512
-V,--vocabs VECTOR ...                Vocabulary file, required for ONNX export
```

### Examples
```
./marian-conv -f model.npz -t model.bin --gemm-type packed16
```
