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

julia> Dict{String, VersionNumber}(k => get_latest_version(v) for (k, v) in COMMON_APPLICATIONS)  # get all available common app versions
Dict{String, VersionNumber} with 8 entries:
  "Team Viewer"           => v"15.25.8"
  "Google Chrome"         => v"98.0.4758"
  "Adobe Acrobat DC"      => v"21.11.20039"
  "Mozilla Firefox"       => v"97.0.1"
  "Microsoft Office 2016" => v"16.0.5278"
  "Microsoft Office 2013" => v"15.0.5423"
  "Microsoft Office 2007" => v"12.0.6612"
  "Microsoft Office 365"  => v"16.0.14827"
  "Microsoft Office 2010" => v"14.0.7261"
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