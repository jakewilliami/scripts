# CommonAppVersions
 
Requires Julia 1.7 because I use `count(::Char, ::AbstractString`, but could easily be refactored by using `count(::Base.Fix2{typeof(==), Char}, ::AbstractString`.