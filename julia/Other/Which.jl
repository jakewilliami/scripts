re = r"^(.*)\((.*)\)$"
m = match(re, join(ARGS, " "))
f, a = Symbol.(m.captures)

R = @eval ccall(:jl_gf_invoke_lookup_worlds, Any,
     (Any, UInt, Ptr{Csize_t}, Ptr{Csize_t}),
     Tuple{typeof($f), typeof($a)},
     ccall(:jl_get_world_counter, UInt, ()),
     Base.RefValue{UInt}(typemin(UInt)),
     Base.RefValue{UInt}(typemax(UInt)))

R.module
R.file
R.line
