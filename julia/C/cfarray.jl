 # https://developer.apple.com/documentation/corefoundation/1388741-cfarraycreate
function _cfarray_create(arr::Vector{T}) where {T <: Unsigned}
    return ccall(:CFArrayCreate, Ptr{UInt32}, 
                 (Ptr{Cvoid}, Ptr{Cvoid}, Int32, Ptr{Cvoid}), 
                 C_NULL, pointer(arr), length(arr), C_NULL)
end
