#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

# A hectomegaunixsecond is one unit of measurement pertaining to n billion, m-hundred-million (m, n ∈ ℕ).
# E.g., 1,600,000,000 seconds (n = 1, m = 6).
# These are the seconds of Unix/Epoch time (number of seconds since 1st January, 1970).

# module SignificantUnixTime

using Dates, Formatting

### Struct definition and helper functions

export HectomegaUnixSecond
export current_hectomegaunixsecond, next_hectomegaunixsecond, next_hectomegaunixsecond_info, hectomegaunixsecond_info

struct HectomegaUnixSecond
	n::Integer
	m::Integer
	value::Integer
	seconds::Dates.Second
	
	
	function HectomegaUnixSecond(n::Integer, m::Integer)
		if n < 0 || m < 0
			error("n and m are used to as constructors for a number n billion and m-hundred-million, which we call a \"hectomegaunixsecond\".  These therefore cannot be negative.  For example, 1,600,000,000 is obtained from n = 1 and m = 6.")
		end
		
		value = (n * 10) + m
		seconds = Second((n * 1_000_000_000) + (m * 100_000_000))
		new(n, m, value, seconds)
	end
end

function HectomegaUnixSecond(S::Integer)
	S′ = S ÷ 100_000_000
	n, m = divrem(S′, 10)
	
	return HectomegaUnixSecond(n, m)
end
HectomegaUnixSecond(S::Dates.Second) =
	HectomegaUnixSecond(S.value)

hectomegaunixsecond2second(S::HectomegaUnixSecond) =
	Second(S.seconds.value)
second2hectomegaunixsecond(S::Dates.Second) =
	HectomegaUnixSecond(S)

Base.convert(::Type{Dates.Second}, S::HectomegaUnixSecond) =
	hectomegaunixsecond2second(S)
Base.convert(::Type{HectomegaUnixSecond}, S::Second) =
	second2hectomegaunixsecond(S)
Base.convert(::Type{HectomegaUnixSecond}, S::Integer) =
	HectomegaUnixSecond(S)
Base.convert(::Type{Integer}, S::HectomegaUnixSecond) =
	S.value
Base.show(io::IO, S::HectomegaUnixSecond) =
	print(io, S.value, " hectomegaunixseconds")

### Other helper function(s)

function readable_dt_format(dt::DateTime)
	dt_str = string(
		Dates.dayname(dt), ", ",
		Dates.day(dt), " ",
		Dates.monthname(dt), " ",
		Dates.year(dt), ", at ",
		Time(dt)
	)
	
	return dt_str
end

# will return the epoch time as an integer
Dates.time(::Type{T}) where {T <: Integer} = round(T, time())
# Dates.time(::Type{T}; sigdigits::Union{Nothing, Int} = nothing) where {T <: Integer} =
# 	round(Int, time())
# will return the epoch time in seconds
Dates.time(::Type{Dates.Second}) = Second(time(Int))

### Main functions for finding next hectomegaunixsecond etc

# # function Dates.time(::Type{HectomegaUnixSecond})
# # 	dt = time(Int)
# # 	HMUS_now = HectomegaUnixSecond(floor(dt, sigdigits=2))
# # 	return HMUS_now
# # end
#
# function Dates.time(::Type{HectomegaUnixSecond})
# 	dt = time(Int)
# 	HMUS_now = HectomegaUnixSecond(dt)
# end
#
# # function Dates.now(::Type{HectomegaUnixSecond})
# # 	dt = time(Int)
# # 	HMUS_now = HectomegaUnixSecond(BigInt(floor(dt, sigdigits=2)))
# #
# # 	return HMUS_now
# # end
#
# Dates.now(::Type{HectomegaUnixSecond}) = time(HectomegaUnixSecond)

function current_hectomegaunixsecond(dt::DateTime)
	unixtime_at_dt = round(Int, datetime2unix(dt))
	HMUS_at_dt = HectomegaUnixSecond(unixtime_at_dt)
	
	return (Second(unixtime_at_dt), HMUS_at_dt)
end
function current_hectomegaunixsecond()
	unixtime_at_dt = time(Int)
	HMUS_at_dt = HectomegaUnixSecond(unixtime_at_dt)
	return (Second(unixtime_at_dt), HMUS_at_dt)
end

function _shift_hectomegaunixsecond(dt::DateTime, n::Integer)
	dt_time, HMUS_at_dt = current_hectomegaunixsecond(dt)
	
	next_HMUS_from_dt = HectomegaUnixSecond(HMUS_at_dt.n, HMUS_at_dt.m + n)
	next_HMUS_as_dt = Dates.unix2datetime(next_HMUS_from_dt.seconds.value)
	
	return (dt_time, next_HMUS_from_dt, next_HMUS_as_dt)
end

function next_hectomegaunixsecond(dt::DateTime)
	dt_time, next_HMUS_from_dt, next_HMUS_as_dt =
		_shift_hectomegaunixsecond(dt, 1)
	
	return (dt_time, next_HMUS_from_dt, next_HMUS_as_dt)
end

function prev_hectomegaunixsecond(dt::DateTime)
	dt_time, prev_HMUS_from_dt, prev_HMUS_as_dt =
		_shift_hectomegaunixsecond(dt, 0)
	
	return (dt_time, prev_HMUS_from_dt, prev_HMUS_as_dt)
end

function current_hectomegaunixsecond_info(unixtime_at_present::Dates.Second)
	info_str = string(
		"It is currently ",
		format(unixtime_at_present.value, commas = true),
		" seconds since 1st January, 1970."
	)
	
	return info_str
end
current_hectomegaunixsecond_info(dt::DateTime) = current_hectomegaunixsecond_info(time(Second))

function prev_hectomegaunixsecond_info(
	unixtime_at_present::Dates.Second,
	prev_HMUS_from_dt::HectomegaUnixSecond,
	prev_HMUS_as_dt::DateTime
)
	
	info_str = string(
		"The previous milestone (at ",
		prev_HMUS_from_dt,
		", or ",
		format(prev_HMUS_from_dt.seconds.value, commas = true),
		" seconds) was on ",
		readable_dt_format(prev_HMUS_as_dt),
		"."
	)
	
	return info_str
end
prev_hectomegaunixsecond_info(dt::DateTime) =
	prev_hectomegaunixsecond_info(prev_hectomegaunixsecond(dt)...)

function next_hectomegaunixsecond_info(
	unixtime_at_present::Dates.Second,
	next_HMUS_from_dt::HectomegaUnixSecond,
	next_HMUS_as_dt::DateTime
)

	info_str = string(
		"The next milestone (at ",
		next_HMUS_from_dt,
		", or ",
		format(next_HMUS_from_dt.seconds.value, commas = true),
		" seconds) is on ",
		readable_dt_format(next_HMUS_as_dt),
		"."
	)

	return info_str
end
next_hectomegaunixsecond_info(dt::DateTime) =
	next_hectomegaunixsecond_info(next_hectomegaunixsecond(dt)...)

function hectomegaunixsecond_info(dt::DateTime)
	current = current_hectomegaunixsecond_info(dt)
	prev = prev_hectomegaunixsecond_info(dt)
	next = next_hectomegaunixsecond_info(dt)
	
	info_str = join([current, prev, next], '\n')
end

# function hectomegaunixseconds_celebrated()
# end

for f in (:hectomegaunixsecond_info, :prev_hectomegaunixsecond, :prev_hectomegaunixsecond_info, :next_hectomegaunixsecond, :next_hectomegaunixsecond_info)
	@eval begin
		# $f(dt::DateTime) = $f(datetime2unix(dt))
		# $f(t::Number) = $f(unix2datetime(t))
		$f() = $f(now())
	end
end

# const PREV_CELEBRATED = Date[
# ]

# end # end module

# using .SignificantUnixTime

# println(next_hectomegaunixsecond_info())
# current_hectomegaunixsecond()

# println(hectomegaunixsecond_info())
# HectomegaUnixSecond(1, 6)
