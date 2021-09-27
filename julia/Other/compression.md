Libz # IO streams; https://github.com/BioJulia/Libz.jl, very fast
`read(ZlibInflateInputStream(data))`

TranscodingStreams, CodecZlib # IO streams; https://github.com/JuliaIO/TranscodingStreams.jl, https://github.com/JuliaIO/CodecZlib.jl
`transcode(GzipDecompressor, data)`

ZLib, ZipFile (ZipFile uses ZLib; ZipFile more file stuff); ZLib is very slow # https://github.com/dcjones/Zlib.jl, https://github.com/fhs/ZipFile.jl/

GZip # Only file IO, slower than it should be (not as slow as GZip); https://github.com/JuliaIO/GZip.jl

XLSX # uses ZipFile; https://github.com/felipenoris/XLSX.jl/