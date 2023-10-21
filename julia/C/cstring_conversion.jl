cstr2str(cstr::Cstring) = ccall(:jl_cstr_to_string, Any, (Cstring,), cstr)::String

p = ccall(:strdup, Cstring, (Cstring,), "hello")
# Cstring(0x0000600001bdb0a0)
ccall(:jl_cstr_to_string, String, (Cstring,), p)
# "hello"
