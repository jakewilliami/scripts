VALEDICTION = raw"$t3g0"
VALEDICTION_BYTES = codeunits(VALEDICTION)
test_img_src = "/Users/jakeireland/Desktop/mccafe.jpg"

#=
function setlastbit()
    return primary_val & 0xfe | UInt8(msg_bit)
end
function setlastbits(primary_val::T, msg_bit::UInt8, nbits::UInt8) where {T <: Integer}
    j = (i >> nbits) << nbits
    return j | (n & ((T(1) << nbits) - T(1)))
end
=#

# setlastbits(UInt8(123), UInt8(0), UInt8(1))

"""
    encode!(src::Matrix{<:Colorant}, msg)

Taking some message, using Least-Significant-Bit Stenography, will encode an image matrix with the message, modifying the matrix in the process.  `msg` should be `Vector{UInt8}` (or a similar iterator), but will work if `msg` is `<: AbstractString`.
"""
function encode!(src::Matrix{C}, msg, fieldnames::NTuple{N, Symbol}) where {C <: Colorant, N <: Integer}
    # get colourant properties
    # n_colour_params = nfields(first(src))
    n_colour_params = length(colour_params)
    # get image properties
    width, height = size(src)
    total_pixels = prod((width, height, n_colour_params))
    # append valediction to message and construct bit generator
    new_msg = vcat(msg, VALEDICTION_BYTES)
    b_msg = Iterators.flatten(BitIterator(b) for b in Iterators.reverse(new_msg))
    req_pixels = length(b_msg)
    
    # ensure image is large enough for message
    if req_pixels > total_pixels
        error("Need larger buffer in which to hide your message")
    end
    
    # Modify src with your image by modifying the least significant bit
    # by zipping the indices of src with the message, the remainder of 
    # src will be unchanged, but we will be modifying src where required
    for (i, msg_bit) in zip(CartesianIndices(src), b_msg)
        pixel = src[i]
        modified_pixel_values = Dict{Symbol, N0f8}()
        for p in colour_params
            # get the colour value as a UInt8, e.g., pixel.r.i (if pixel <: RGB)
            primary_val = getfield(pixel, p).i # a UInt8 (from a Normed Int8)
            # bitwise operations to set the least significant bit
            # ref: https://stackoverflow.com/a/19744407/12069968
            modified_pixel_values[p] = reinterpret(N0f8, primary_val & 0xfe | UInt8(msg_bit))
            # modified_pixel_values[p] = 
                # reinterpret(N0f8, parse(UInt8, bitstring(primary_val) * msg_bit, base = 2))
        end
        src[i] = C((modified_pixel_values[p] for p in colour_params)...)
    end
    
    return src
end
function encode!(src::Matrix{C}, msg::S, fieldnames::NTuple{N, Symbol}) where {C <: Colorant, S <: AbstractString, N <: Integer}
    return encode!(src, codeunits(msg))
end

encode(src::S, msg, fieldnames::NTuple{N, Symbol}) where {S <: AbstractString} = encode!(load(src), msg)
# encode(src::S, msg, dest::) where {S, S2 <: AbstractString} = encode!(load(src), msg)

function encode(src::Matrix{C}, msg) where {C <: Colorant}
    colour_type = eltype(src)
    if colour_type <: AbstractRGB && colour_type.ninitialized == 3
        return encode(src, msg, (:r, :g, :b))
    elseif colour_type <: AbstractGray && colour_type.ninitialized == 1
        return encode(src, msg, (:val, ))
    end
    # if not grayscale or rgb, default to the field names (this may fail :( )
    return encode(src, msg, fieldnames(C))
end

#=====================================#

#=
function encode(byte::UInt8, enc_byte::UInt8)    
end

# function embed(img::Matrix{Colorant}, msg::Vector{UInt8}, end_msg::Vector{UInt8})
function embed(img::Matrix{AbstractRGB}, msg::Vector{UInt8}, end_msg::Vector{UInt8})
    
end
=#


# @btime encode(test_img_src, raw"I've been expecting you, Mr. Bond");
