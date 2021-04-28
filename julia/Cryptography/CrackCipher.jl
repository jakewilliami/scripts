#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

using ClassicalCiphers

str = join(ARGS[1:end], " ")

println("Result from best guess at a Caesar shift:")
caesar_res = crack_caesar(str)
println("$(caesar_res)\n")

println("Result from best guess at a substitution (monoalphabetic) cipher:")
monoalphabetic_res = crack_monoalphabetic(str)
println("$(monoalphabetic_res)\n")

println("Result from best guess at a Affine cipher:")
affine_res = crack_affine(str)
println("$(affine_res)\n")

println("Result from best guess at a Vigenere cipher:")
vigenere_res = crack_vigenere(str)
println("$(vigenere_res)\n")
