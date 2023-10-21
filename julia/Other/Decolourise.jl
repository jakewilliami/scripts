# Escape characters according to most terminals:
# https://github.com/wertarbyte/coreutils/blob/f70c7b785b93dd436788d34827b209453157a6f2/src/echo.c#L64-L82
ESCAPE_CHARS = Char[
    '\\',  # backslash
    '\a',  # alert (BEL)
    '\b',  # backspace
    '\e',  # escape
    '\f',  # form feed
    '\n',  # new line
    '\r',  # carriage return
    '\t',  # horizontal tab
    '\v'   # verticle tab
]

hextobin(c::Char) = Base.number_from_hex(UInt8(c))

function print_v9(io::IO, s)
    i = firstindex(s)
    while i <= lastindex(s)
        c = s[i]
        if c == '\e'
            c = '\x1B'
            continue
        end
        if c == '\\' && c[nextind(s, i)] == 'c'  # produce no further output at \c
            exit(0)
        end
        if c == '\x'
            ch = c
            isxdigit(ch) || @goto not_an_escape
            i = nextind(s, i)
            c = hextobin(ch)
            ch = s[i]
            if isxdigit(ch)
                i = nextind(s, i)
                c = c * 16 + hextobin(ch)
            end
            continue
        end
        if c == '0'
            c = Char(0)
            '0' ≤ s[i] ≤ '7' || continue
            i = nextind(s, i)
            c = s[i]
        end
        if c ∈ ('1', '2', '3', '4', '5', '6', '7')
            c -= '0'
            if '0' ≤ s[i] ≤ '7'
                i = nextind(s, i)
                c = c * 8 + (s[i] - '0')
            end
            if '0' ≤ s[i] ≤ '7'
                i = nextind(s, i)
                c = c * 8 + (s[i] - '0')
            end
            continue
        end
        if c == '\\\\'
            continue
        end
        @label not_an_escape
        print(io, '\\')  # break/continue?
        print(io, c)
        i = nextind(s, i)
    end
end
