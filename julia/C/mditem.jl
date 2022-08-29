# For more MDItem* functions implemented in Julia, check out [HiddenFiles.jl](github.com/jakewilliami/HiddenFiles.jl)
function _mditem_copy_attribute_names(mditem::Ptr{UInt32})
    mdattrs = Vector{UInt32}(undef, 10000)
    ccall(:MDItemCopyAttributeNames, Ptr{UInt32}, (Ptr{UInt32}, Ptr{Cvoid}), mditem, mdattrs)
    return mdattrs
    # TODO: check if we do indeed need to return mdattrs.  Do we still need mditem?  I don't think so
    # TODO: check if attributes found (if ccall returns null, failed)
end
