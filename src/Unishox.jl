module Unishox
    
using Unishox_jll   
    
    export compress, decompress
    
    function compress(s::AbstractString)
        isempty(s) && return ""

        # The output should be no longer than the input
        compressed = Array{Cchar}(undef, sizeof(s))

        # The function modifies `compressed` and returns the number of bytes written
        nbytes = ccall((:unishox2_compress_simple, libunishox), Cint,
                        (Ptr{Cchar}, Cint, Ptr{Cchar}),
                        s, sizeof(s), compressed)

        # Failed compression is shoco's fault, not ours >_>
        nbytes > 0 || throw(ErrorException("Compression failed for input $s"))

        compressed = compressed[1:nbytes]
        compressed[end] == Cchar(0) || push!(compressed, Cchar(0))

        return unsafe_string(pointer(compressed))
    end


    function decompress(s::AbstractString)
        isempty(s) && return ""

        # The decompressed string will be at most twice as long as the input
        decompressed = Array{Cchar}(undef, 3 * sizeof(s))

        nbytes = ccall((:unishox2_decompress_simple, libunishox), Cint,
                        (Ptr{Cchar}, Cint, Ptr{Cchar}),
                        s, sizeof(s), decompressed)

        nbytes > 0 || throw(ErrorException("Decompression failed for input $s"))

        decompressed = decompressed[1:nbytes]
        decompressed[end] == Cchar(0) || push!(decompressed, Cchar(0))

    return unsafe_string(pointer(decompressed))
    end

    
end
