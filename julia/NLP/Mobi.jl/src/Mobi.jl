module Mobi

include("lz77.jl")

struct Mobi
    contents::Any
    header::Any
    records::Any
    config::Any
end

function read_record(mobi::Mobi, recordnum; disable_compression::Bool = false)
    if !isempty(mobi.config)
        if mobi.config["palmdoc"]["Compression"] == 1 || disable_compression
            return mobi.contents[mobi.records[recordnum]["record Data Offset"]:mobi.records[recordnum + 1]["record Data Offset"]]
        elseif mobi.config["palmdoc"]["Compression"] == 2
            return decompress_lz77(mobi.contents[mobi.records[recordnum]["record Data Offset"]:(mobi.records[recordnum + 1]["record Data Offset"] - mobi.config["mobi"]["extra bytes"])])
        end
    end
    return nothing
end

function read_image_record(mobi::Mobi, imgnum)
    if !isempty(mobi.config)
        recordnum = mobi.config["mobi"]["First Image index"] + imgnum
        return read_record(mobi, recordnum, disable_compression = true)
    end
    return nothing
end

"""
```julia
author(mobi::Mobi)
```
Returns the author of the book.
"""
function author(mobi::Mobi)
    return mobi.config["exth"]["records"][100]
end

"""
```julia
title(mobi::Mobi)
```
Returns the title of the book.
"""
function title(mobi::Mobi)
    return mobi.config["mobi"]["Full Name"]
end

### Private API

end # end module
