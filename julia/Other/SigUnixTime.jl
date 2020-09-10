#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Other/" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

using Dates

rn = convert(BigInt, round(time()))
rn_unix = unix2datetime(rn)

nextBigThing = convert(BigInt, ceil(rn, sigdigits=2))
nextBigDateTime = unix2datetime(nextBigThing)

println("It is currently $rn in unix time.  The next milestone ($nextBigThing) is at $nextBigDateTime.")
