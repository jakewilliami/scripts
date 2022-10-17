# Natural sorting is how bash's `sort -n` works, in that
# it can parse numbers and alphanumeric characters.
# 
# Written for fun by Jake Ireland, in October, 2022.
# 
# Inspiration from this video: 
# https://www.youtube.com/watch?v=RaE66ycBRE0

using ReadableRegex


# See note below on why we can't use `one_or_more`
# const DIGIT_CAPTURE_RE_STR = capture(one_or_more(DIGIT))
const DIGIT_CAPTURE_RE_STR = capture(DIGIT)
const DIGIT_CAPTURE_KEEP_DIGIT_RE_STR = either(
        look_for("", before = DIGIT_CAPTURE_RE_STR),
        look_for("", after = DIGIT_CAPTURE_RE_STR)
    )
const NATURAL_KEY_REGEX = Regex(DIGIT_CAPTURE_KEEP_DIGIT_RE_STR)


# Split a string into its (parsed) number components and its string
# components.  This function returns a 
# `Tuple{Vector{Union{AbstractString, Int}}, AbstractString}`.
# This is ultimately to be used in the `sort` function (with the
# `by` keyword).
# The reason it returns a tuple with a string (which is the original
# string provided) is so that `sort` can decide on tie breakers using
# lexigraphical ordering (i.e., "300_foo.txt" and "0300_foo.txt" both
# have the same split output, as "300" and "0300" are parsed the same;
# however "0300_foo.txt" should be put first in the sorted array as it
# is lexigraphically less than "300_foo.txt"
function natural_key(s::AbstractString)
    # Unfortunately, Julia does not yet have the functionality to
    # split by regex _and keep the delimiter_: JuliaLang/julia#20625.
    # We do have a workaround using some fancy regular expression: 
    # https://discourse.julialang.org/t/51995/2, however for the 
    # present programme we ideally need to match '(\d+)' (rather than
    # the currently-implemented '(\d)'.  The workaround (until we get
    # a `keepdelim` option for `split`) uses Perl-comparible regex's 
    # lookbehind, however PCRE does not support + or * for lookbehind: 
    # https://stackoverflow.com/a/66309267/12069968.  As a result, a
    # split array that should look like
    #     ["400", "_file.txt"]
    # Must look like
    #     ["4", "0", "0", "_file.txt"]
    # The output we want is a mixture of parsed numbers and strings:
    #     [400, "_file.txt"]
    # The present function is a way to correctly parse the split
    # results given our regex limitations.
    function _collate_split_results(splt_arr::Vector{S}) where {S <: AbstractString}
        out_arr = Vector{Union{AbstractString, Int}}()
        digit_io = IOBuffer()
        for part in splt_arr
            # If this part is still a digit, print to the digit buffer
            if all(isdigit, part)
                # Due to the regex compromise we have had to make,
                # the substrings that are digits should all have
                # length of one (i.e., single characters that are
                # necessarily digits)
                @assert isone(length(part))
                print(digit_io, part)
            else
                # If not a digit, take from the digit buffer and
                # parse the previously recorded digits as an integer
                ds = take!(digit_io)
                if !isempty(ds)
                    # We need to ensure that the split results alternate
                    # between string component and integer component, 
                    # otherwise we may get errors from `sort` trying to 
                    # compare strings with integers, &c. As such, if we 
                    # are pushing an integer, we must ensure that the 
                    # previous item was a string.
                    i = prevind(out_arr, length(out_arr))
                    if (isassigned(out_arr, i) && out_arr[i] isa AbstractString) || isempty(out_arr)
                        push!(out_arr, "")
                    end
                    push!(out_arr, parse(Int, String(ds)))
                end
                push!(out_arr, part)
            end
        end
        # Do a final assert to make sure out output alternates correctly
        @assert all(out_arr[i] isa (AbstractString, Int)[mod1(i, 2)] for i in eachindex(out_arr)) "Must have alternating strings/ints: $out_arr"
        return out_arr
    end
    
    split_res = split(s, NATURAL_KEY_REGEX)
    return (_collate_split_results(split_res), s)
end


function natural_sort(arr; kwargs...)
    return sort(arr; by = natural_key, kwargs...)
end



### Tests

using Test

function test_natural_sort()
    TEST_CASES = [
        "PyYAML-5.4-cp38-cp38-macosx_10_9_x86_64.whl",
        "PyYAML-6.0-cp310-cp310-manylinux_2_5_x86_64.manylinux1_x86_64.manylinyx_2_12_x86_64.manylinux2010_x86_64.whl",
        "PyYAML-5.4-cp310-cp310-manylinux_2_28_x86_64.whl",
        "PyYAML-6.0-cp39-cp39-macosx_11_0_arm64.whl",
        "PyYAML-6.0-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl",
        "PyYAML-6.0-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl",
        "PyYAML-6.0-cp39-cp39-macosx_10_9_x86_64.whl",
        "PyYAML-6.0-cp310-cp310-macosx_11_0_arm64.whl"
    ]
    EXPECTED_OUTPUT = [
        "PyYAML-6.0-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl",
        "PyYAML-6.0-cp310-cp310-manylinux_2_5_x86_64.manylinux1_x86_64.manylinyx_2_12_x86_64.manylinux2010_x86_64.whl",
        "PyYAML-6.0-cp310-cp310-macosx_11_0_arm64.whl",
        "PyYAML-6.0-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl",
        "PyYAML-6.0-cp39-cp39-macosx_11_0_arm64.whl",
        "PyYAML-6.0-cp39-cp39-macosx_10_9_x86_64.whl",
        "PyYAML-5.4-cp310-cp310-manylinux_2_28_x86_64.whl",
        "PyYAML-5.4-cp38-cp38-macosx_10_9_x86_64.whl",
    ]
    
    ns_results = natural_sort(TEST_CASES; rev = true)
    for (r, e) in zip(ns_results, EXPECTED_OUTPUT)
        @test r == e
    end
    
    TEST_CASES_2 = vcat(["$(i)_foo.txt" for i in 1:10], ["300_foo.txt", "-1_foo.txt", "hello100", "0300_foo.txt"])
    EXPECTED_OUTPUT_2 = [
        "1_foo.txt", 
        "2_foo.txt", 
        "3_foo.txt", 
        "4_foo.txt", 
        "5_foo.txt", 
        "6_foo.txt", 
        "7_foo.txt", 
        "8_foo.txt", 
        "9_foo.txt", 
        "10_foo.txt", 
        "0300_foo.txt", 
        "300_foo.txt", 
        "-1_foo.txt", 
        "hello100",
    ]
    
    ns_results_2 = natural_sort(TEST_CASES_2)
    for (r, e) in zip(ns_results_2, EXPECTED_OUTPUT_2)
        @test r == e
    end
end
