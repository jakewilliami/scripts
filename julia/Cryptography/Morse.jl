# abstract type MorseCode <: AbstractVector end
abstract type MorseChar <: AbstractChar end
# abstract type MorseLetter <: AbstractVector end

struct MorseDot <: MorseChar
    val::Char
end
struct MorseDash <: MorseChar
    val::Char
end

const morsedot = MorseDot(Char(0x002E)) # '.'
const morsedash = MorseDash(Char(0x2014)) # '—'
const morsedash_alt = MorseDash(Char(0x002D)) # '-'

struct MorseLetter
    # letter::Char
    letter::Vector{<:MorseChar}
    cp::UInt32
end
MorseLetter(letter::Vector{<:MorseChar}) = MorseLetter(letter, UInt32(1))
Base.codepoint(letter::MorseLetter) = letter.cp

struct MorseWord
    word::Vector{MorseLetter}
end

struct MorseCode
    sentence::Vector{MorseWord}
end

morse_map = Dict{Char, MorseLetter}(
    'a' => MorseLetter([morsedot, morsedash]), # .—
    'b' => MorseLetter([morsedash, morsedot, morsedot, morsedot]), # —...
    'c' => MorseLetter([morsedash, morsedot, morsedash, morsedot]), # —.—.
    'd' => MorseLetter([morsedash, morsedot, morsedot]), # —..
    'e' => MorseLetter([morsedot]), # .
    'f' => MorseLetter([morsedot, morsedot, morsedash, morsedot]), # ..—.
    'g' => MorseLetter([morsedash, morsedash, morsedot]), # ——.
    'h' => MorseLetter([morsedot, morsedot, morsedot, morsedot]), # ....
    'i' => MorseLetter([morsedot, morsedot]), # ..
    'j' => MorseLetter([morsedot, morsedash, morsedash, morsedash]), # .———
    'k' => MorseLetter([morsedash, morsedot, morsedash]), # —.—
    'l' => MorseLetter([morsedot, morsedash, morsedot, morsedot]), # .—..
    'm' => MorseLetter([morsedash, morsedash]), # ——
    'n' => MorseLetter([morsedash, morsedot]), # —.
    'o' => MorseLetter([morsedash, morsedash, morsedash]), # ———
    'p' => MorseLetter([morsedot, morsedash, morsedash, morsedot]), # .——.
    'q' => MorseLetter([morsedash, morsedash, morsedot, morsedash]), # ——.—
    'r' => MorseLetter([morsedot, morsedash, morsedot]), # .—.
    's' => MorseLetter([morsedot, morsedot, morsedot]), # ...
    't' => MorseLetter([morsedash]), # —
    'u' => MorseLetter([morsedot, morsedot, morsedash]), # ..—
    'v' => MorseLetter([morsedot, morsedot, morsedot, morsedash]), # ...—
    'w' => MorseLetter([morsedot, morsedash, morsedash]), # .——
    'x' => MorseLetter([morsedash, morsedot, morsedot, morsedash]), # —..—
    'y' => MorseLetter([morsedash, morsedot, morsedash, morsedash]), # —.——
    'z' => MorseLetter([morsedash, morsedash, morsedot, morsedot]) # ——..
)

msg = MorseCode([
    MorseWord([
        MorseLetter([morsedot, morsedot, morsedot, morsedot]),
        MorseLetter([morsedot]),
        MorseLetter([morsedot, morsedash, morsedot, morsedot]),
        MorseLetter([morsedot, morsedash, morsedot, morsedot]),
        MorseLetter([morsedash, morsedash, morsedash])
    ]),
    MorseWord([
        MorseLetter([morsedot, morsedash, morsedash]),
        MorseLetter([morsedash, morsedash, morsedash]),
        MorseLetter([morsedot, morsedash, morsedot]),
        MorseLetter([morsedot, morsedash, morsedot, morsedot]),
        MorseLetter([morsedash, morsedot, morsedot])
    ])
])

println(msg)

reverse_map = Dict(reverse(p) for p in morse_map)
# println(join(reverse_map[c] for c in msg))

# need to improve iteration over words
# need to define display for words
# need to dispatch on parse
