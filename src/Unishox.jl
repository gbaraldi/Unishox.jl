module Unishox
    
using Unishox_jll   
    
    export compress, decompress

    """
        compress(s::AbstractString)

    Compresses a string using the unishox library and returns it.
    """
    function compress(s::AbstractString)
        isempty(s) && return ""

        # The output is usually smaller than the input but there's no such guarantee
        compressed = Array{Cchar}(undef, 2*sizeof(s))

        # The function modifies `compressed` and returns the number of bytes written
        nbytes = ccall((:unishox2_compress_simple, libunishox), Cint,
                        (Ptr{Cchar}, Cint, Ptr{Cchar}),
                        s, sizeof(s), compressed)

        # Failed compression is unishox's fault, not ours >_>
        nbytes > 0 || throw(ErrorException("Compression failed for input $s"))

        compressed = compressed[1:nbytes]

        return unsafe_string(pointer(compressed), nbytes)
    end

    """
        decompress(s::AbstractString)
    
    Decompresses a string previously compressed by unishox and returns it.
    """
    function decompress(s::AbstractString)
        isempty(s) && return ""
        
        decompressed = Array{Cchar}(undef, 3 * sizeof(s))

        nbytes = ccall((:unishox2_decompress_simple, libunishox), Cint,
                        (Ptr{Cchar}, Cint, Ptr{Cchar}),
                        s, sizeof(s), decompressed)

        if nbytes > 3 * sizeof(s)
            decompressed = Array{Cchar}(undef, nbytes + 2)
            nbytes = ccall((:unishox2_decompress_simple, libunishox), Cint,
                        (Ptr{Cchar}, Cint, Ptr{Cchar}),
                        s, sizeof(s), decompressed)
        end

        nbytes > 0 || throw(ErrorException("Decompression failed for input $s"))

        decompressed = decompressed[1:nbytes]

    return unsafe_string(pointer(decompressed), nbytes)
    end

    
end
