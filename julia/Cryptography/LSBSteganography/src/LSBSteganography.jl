module LSBSteganography

using Images, FileIO

#=
julia> print_tree(find_supersupertype(Gray))
Colorant{T, 1} where T<:Union{Bool, AbstractFloat, FixedPoint}
├─ AbstractGray{T} where T<:Union{Bool, AbstractFloat, FixedPoint}
│  ├─ Gray
│  └─ Gray24
└─ TransparentColor{C, T, 1} where {C<:Color, T<:Union{Bool, AbstractFloat, FixedPoint}}
   ├─ AlphaColor{C, T, 1} where {C<:Color, T<:Union{Bool, AbstractFloat, FixedPoint}}
   └─ ColorAlpha{C, T, 1} where {C<:Color, T<:Union{Bool, AbstractFloat, FixedPoint}}

julia> print_tree(find_supersupertype(RGB))
Colorant{T, 3} where T<:Union{AbstractFloat, FixedPoint}
├─ Color3{T} where T<:Union{AbstractFloat, FixedPoint}
│  ├─ AbstractRGB{T} where T<:Union{AbstractFloat, FixedPoint}
│  │  ├─ BGR
│  │  ├─ RGB
│  │  ├─ RGB24
│  │  ├─ RGBX
│  │  └─ XRGB
│  ├─ DIN99
│  ├─ DIN99d
│  ├─ DIN99o
│  ├─ HSI
│  ├─ HSL
│  ├─ HSV
│  ├─ LCHab
│  ├─ LCHuv
│  ├─ LMS
│  ├─ Lab
│  ├─ Luv
│  ├─ XYZ
│  ├─ YCbCr
│  ├─ YIQ
│  └─ xyY
└─ TransparentColor{C, T, 3} where {C<:Color, T<:Union{AbstractFloat, FixedPoint}}
   ├─ AlphaColor{C, T, 3} where {C<:Color, T<:Union{AbstractFloat, FixedPoint}}
   └─ ColorAlpha{C, T, 3} where {C<:Color, T<:Union{AbstractFloat, FixedPoint}}

julia> print_tree(find_supersupertype(AGray32))
ColorantNormed{N0f8, 2}
├─ Color{N0f8, 2}
└─ TransparentColor{C, N0f8, 2} where C<:Color
   ├─ AlphaColor{C, N0f8, 2} where C<:Color
   │  ├─ AGray32
   │  └─ AGray{N0f8}
   └─ ColorAlpha{C, N0f8, 2} where C<:Color
      └─ GrayA{N0f8}
=#

include("biterate.jl")
include("encode.jl")

export encode, decode

end # end module
