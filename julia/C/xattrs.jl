# https://opensource.apple.com/source/xnu/xnu-1228.0.2/bsd/sys/xattr.h.auto.html
const XATTR_NOFOLLOW = 0x0001

# https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man2/getxattr.2.html
const XATTR_SIZE = 10_000
function _getxattr(f::AbstractString, value_name::String)
    value = Vector{Char}(undef, XATTR_SIZE)
    value_len = ccall(:getxattr, Cssize_t, 
                      (Cstring, Cstring, Ptr{Cvoid}, Csize_t, UInt32), 
                      f, value_name, value, XATTR_SIZE, XATTR_NOFOLLOW)
    value_len == -1 && error("Couldn't get value \"$value_name\" from path \"$f\"")
    return value
end

