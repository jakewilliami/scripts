# CommonAppVersions

## Notes
  - This uses some web-scraping, which isn't the most reliable method of gathering data...
  - We only care about the major, minor, and micro versions in this API (if it is stable enough to call it that).

## Prerequisites
Requires Julia 1.7 because I use `count(::Char, ::AbstractString`, but could easily be refactored by using `count(::Base.Fix2{typeof(==), Char}, ::AbstractString`.

## Example
```julia
julia> using CommonAppVersions

julia> get_latest_version(Firefox)
v"97.0.1"

julia> get_latest_version(Chrome)
v"98.0.4758"

julia> get_latest_version(Adobe)
v"21.11.20039"

julia> get_latest_version(Office365)
v"16.0.14729"

julia> get_latest_version(Office2013)
v"15.0.5423"
```