# CommonAppVersions

## Notes
  - This uses some web-scraping, which isn't the most reliable method of gathering data...
  - We only care about the major, minor, and micro versions in this API (if it is stable enough to call it that).

## Prerequisites
Requires Julia 1.7 because I use `count(::Char, ::AbstractString`, but could easily be refactored by using `count(::Base.Fix2{typeof(==), Char}, ::AbstractString`.

## Usage
```julia
get_latest_version(::CommonApplication, ::OperatingSystem = Windows)::VersionNumber
```

## Example
```julia
julia> using CommonAppVersions

julia> get_latest_version(Firefox)  # get the latest version of Mozilla Firefox
v"97.0.1"

julia> get_latest_version(Chrome)  # the latest versions will default to Windows
v"98.0.4758"

julia> get_latest_version(Chrome, Linux)  # Specify the operating system of the latest Chrome version
v"98.0.4758"

julia> get_latest_version(TeamViewer, Linux)  # not all operating systems are supported for each app
ERROR: # ...
```

## Custom Types

### `OperatingSystem`
  - `Windows`
  - `MacOS`
  - `Linux`

### `CommonApplication`
  - `Firefox`
  - `Chrome`
  - `Adobe`
  - `TeamViewer`
  - `Office2007`
  - `Office2010`
  - `Office2013`
  - `Office2016`
  - `Office365`

See also `COMMON_APPLICATIONS`