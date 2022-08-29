# NOTE: currently these functions are not working!
function _cfdictionary_create(keys::Vector{T}, values::Vector{T}) where {T <: Unsigned}
    return ccall(:CFDictionaryCreate, Ptr{UInt32}, 
                 (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}, Int32, Ptr{Cvoid}), 
                 C_NULL, pointer(keys), pointer(values), length(keys), C_NULL)
end
_cfdictionary_create(D::AbstractDict{T, T}) where {T <: Unsigned} = 
    _cfdictionary_create(collect(keys(D)) collect(values(D)))
