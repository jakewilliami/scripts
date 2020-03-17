#! /usr/bin/env julia

x = parse(Float64, ARGS[1])
y = parse(Float64, ARGS[2])
#if it is a float with .0, print as integer, otherwise, print as float
a = (x * y)
if isinteger(a) == true
    print(trunc(Int64, a))
else
print(a)
end

#=
function <function-name()>
        <function-code>
end
=#
    
#eltype(a) #element type or variable a
