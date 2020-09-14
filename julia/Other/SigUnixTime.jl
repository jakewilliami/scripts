#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

using Dates

DTFormat(d::DateTime) = string(Dates.dayname(d), ", ", Dates.day(d), " ", Dates.monthname(d), " ", Dates.year(d), ", at ", )

rn = convert(BigInt, round(datetime2unix(now())))
rn_unix = Dates.unix2datetime(rn)

nextBigThing = convert(BigInt, ceil(rn, sigdigits=2))
nextBigDateTime = Dates.unix2datetime(nextBigThing)

println("It is currently $rn in unix time.  The next milestone ($nextBigThing) is on ", DTFormat(nextBigDateTime), Time(nextBigDateTime), ".")
