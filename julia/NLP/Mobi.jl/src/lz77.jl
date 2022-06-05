# import struct
# ported directly from the PalmDoc Perl library
# http://kobesearch.cpan.org/htdocs/EBook-Tools/EBook/Tools/PalmDoc.pm.html

function decompress_lz77(data::Vector{UInt8})
    len = length(data)
    offset = 1
    # Current offset into data
    # char;      # Character being examined
    # ord;      # Ordinal of $char
    # lz77;      # 16-bit Lempel-Ziv 77 length-offset pair
    # lz77offset;   # LZ77 offset
    # lz77length;   # LZ77 length
    # lz77pos;    # Position inside $lz77length
    # text = ""   # Output (uncompressed) text
    text = UInt8[]
    # textlength;   # Length of uncompressed text during LZ77 pass
    # textpos;    # Position inside $text during LZ77 pass
    
    while offset <= len
        # char = substr($data,$offset++,1);
        c = data[offset]
        offset += 1
        byte = Int(c)
        
        # The long if-elsif chain is the best logic for $ord handling
        ## no critic (Cascading if-elsif chain)
        if iszero(byte)
            # Nulls are literal
            # text *= c
            push!(text, c)
        elseif byte <= 8
            # text *= data[offset:(offset + byte)]
            for b in data[offset:(offset + byte)]
                push!(text, b)
            end
            offset += byte
        elseif byte <= 0x7f
            # Values from 0x09 through 0x7f are literal
            # text *= c
            push!(text, c)
        elseif byte <= 0xbf
            # Data is LZ77-compressed
            
            # From Wikipedia:
            # "A length-distance pair is always encoded by a two-byte
            # sequence. Of the 16 bits that make up these two bytes,
            # 11 bits go to encoding the distance, 3 go to encoding
            # the length, and the remaining two are used to make sure
            # the decoder can identify the first byte as the beginning
            # of such a two-byte sequence."
            
            offset += 1
            if offset >= length(data)
                @warn "Offset to LZ77 bits is outside of the data: $offset"
                return text
            end
            
            # lz77, = struct.unpack('>H', data[offset-2:offset]) # > is big endian, H is unsigned short
            # lz77 = hton(read(IOBuffer("ab"), UInt16))
            lz77 = hton(read(IOBuffer(data[(offset - 2):offset]), UInt16))
            
            # Leftmost two bits are ID bits and need to be dropped
            lz77 &= 0x3fff
            
            # Length is rightmost 3 bits + 3
            lz77_length = (lz77 & 0x0007) + 3
            
            # Remaining 11 bits are offset
            lz77_offset = lz77 >> 3
            if lz77_offset < 1
                @warn "LZ77 decompression offset is invalid!"
                return text
            end
            
            # Getting text from the offset is a little tricky, because
            # in theory you can be referring to characters you haven't
            # actually decompressed yet. You therefore have to check
            # the reference one character at a time.
            text_length = length(text);
            for lz77_pos in 1:lz77_length # for($lz77pos = 0; $lz77pos < $lz77length; $lz77pos++)
                text_pos = text_length - lz77_offset
                if text_pos < 1
                    @warn "LZ77 decompression reference is before beginning of text! $lz77"
                    return nothing
                end
                
                # text *= text[text_pos:(text_pos + 1)] #text .= substr($text,$textpos,1);
                for b in text[text_pos:(text_pos + 1)]
                    push!(text, )
                end
                text_length += 1
            end
        else
            # 0xc0 - 0xff are single characters (XOR 0x80) preceded by a space
            text *= ' ' * Char(byte ^ 0x80)
        end
    end
    
    return text
end
