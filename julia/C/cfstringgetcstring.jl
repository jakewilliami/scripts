# https://opensource.apple.com/source/CF/CF-635/CFString.h.auto.html
# https://developer.apple.com/documentation/corefoundation/cfstringbuiltinencodings
const K_CFSTRING_ENCODING_MACROMAN = 0x0
const K_CFSTRING_ENCODING_WINDOWSLATIN1 = 0x0500 # ANSI codepage 1252
const K_CFSTRING_ENCODING_ISOLATIN1 = 0x0201     # ISO 8859-1
const K_CFSTRING_ENCODING_NEXTSTEPLATIN = 0x0B01 # NextStep encoding
const K_CFSTRING_ENCODING_ASCII = 0x0600         # 0..127 (in creating CFString, values greater than 0x7F are treated as corresponding Unicode value)
const K_CFSTRING_ENCODING_UNICODE = 0x0100       # kTextEncodingUnicodeDefault  + kTextEncodingDefaultFormat (aka kUnicode16BitFormat)
const K_CFSTRING_ENCODING_UTF8 = 0x08000100      # kTextEncodingUnicodeDefault + kUnicodeUTF8Format
const K_CFSTRING_ENCODING_NONLOSSYASCII = 0x0BFF # 7bit Unicode variants used by Cocoa & Java
const K_CFSTRING_ENCODING_UTF16 = 0x0100         # kTextEncodingUnicodeDefault + kUnicodeUTF16Format (alias of kCFStringEncodingUnicode)
const K_CFSTRING_ENCODING_UTF16BE = 0x10000100   # kTextEncodingUnicodeDefault + kUnicodeUTF16BEFormat
const K_CFSTRING_ENCODING_UTF16LE = 0x14000100   # kTextEncodingUnicodeDefault + kUnicodeUTF16LEFormat
const K_CFSTRING_ENCODING_UTF32 = 0x0c000100     # kTextEncodingUnicodeDefault + kUnicodeUTF32Format
const K_CFSTRING_ENCODING_UTF32BE = 0x18000100   # kTextEncodingUnicodeDefault + kUnicodeUTF32BEFormat
const K_CFSTRING_ENCODING_UTF32LE = 0x1c000100   # kTextEncodingUnicodeDefault + kUnicodeUTF32LEFormat

# https://opensource.apple.com/source/CF/CF-368/String.subproj/CFStringUtilities.c.auto.html
# https://developer.apple.com/documentation/corefoundation/1542942-cfstringcreatewithcstring
const K_CF_STRING_ENCODING_UTF8 = UInt32(65001)

# This function was written as part of the macOS implementation of `ishidden`, for the [HiddenFiles.jl](github.com/jakewilliami/HiddenFiles.jl) package.  I didn't end up needing this specific function, but thought someone, oneday, might find it useful so am putting this here.
function _cfstring_get_c_string(s::AbstractString, encoding::Unsigned = K_CFSTRING_ENCODING_MACROMAN)
    cfbuf = Vector{UInt32}(undef, 1000)
    ccall(:CFStringGetCString, Bool, 
          (Cstring, Ptr{Cvoid}, Int32, UInt32),
          _cfstring_create_with_cstring(s, encoding), cfbuf, sizeof(cfbuf), 0) || error("Problem calling CFStringGetCString")
    return cfbuf
end

function _cfstring_get_cstring(cfbuf::Vector{Char}, cfstr::Cstring, encoding::Unsigned = K_CFSTRING_ENCODING_MACROMAN)
    ccall(:CFStringGetCString, Bool,
          (Cstring, Ptr{Cvoid}, Int32, UInt32),
          cfstr, cfbuf, sizeof(cfbuf), 0) || error("Problem calling CFStringGetCString")
    return cfbuf
end

