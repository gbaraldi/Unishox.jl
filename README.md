# Unishox

[![Build Status](https://github.com/gbaraldi/Unishox.jl/workflows/CI/badge.svg)](https://github.com/gbaraldi/Unishox.jl/actions?query=workflow%3ACI+branch%3Amaster)
[![codecov.io](http://codecov.io/github/gbaraldi/Unishox.jl/coverage.svg?branch=main)](http://codecov.io/github/gbaraldi/Unishox.jl?branch=main)

**Unishox.j;** is a Julia package that provides access to the compression and decompression functions in the [**Unishox**](https://github.com/siara-cc/Unishox2) C library.
It's algorithms are optimized for short Unicode strings. Compression is performed using an hybrid encoder that uses entropy, dictionary and delta encoding. For more details check the [**article**](https://github.com/siara-cc/Unishox2/blob/master/Unishox_Article_2.pdf?raw=true)

Two functions are exported by this package: `compress` and `decompress`.
Both accept a single `AbstractString` argument and return a `String`.

Here's an example using the functions at the REPL.

```julia
julia> using Unishox

julia> s = "😆I can do emojis"
"😆I can do emojis"

julia> sizeof(s)
19

julia> compressed = compress(s)
"\x9f\xc0R\xe3\x05\xaeg\x17T\x9f\x9a\xfd\xbd\x17"

julia> sizeof(compressed)
14

julia> decompress(compressed)
"😆I can do emojis"
```

This package is based on the [**Shoco.jl**](https://github.com/ararslan/Shoco.jl) package.
