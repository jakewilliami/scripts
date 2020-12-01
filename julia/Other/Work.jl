#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

using Dates

const _today = today()
const _now = now()

const _start_dates = Date[
	Date(2018, Oct, 31),
	Date(2018, Nov, 28),
	Date(2018, Dec, 26),
	Date(2019, Jan, 23),
	Date(2019, Feb, 13),
	Date(2019, Mar, 13),
	Date(2019, Apr, 10),
	Date(2019, May, 8),
	Date(2019, Jun, 5),
	Date(2019, Jul, 3),
	Date(2019, Jul, 31),
	Date(2019, Aug, 28),
	Date(2019, Sep, 25),
	Date(2019, Oct, 23),
	Date(2019, Nov, 20),
	Date(2019, Dec, 18),
	Date(2020, Jan, 15),
	Date(2020, Feb, 12),
	Date(2020, Mar, 11),
	Date(2020, Apr, 8),
	Date(2020, May, 6),
	Date(2020, Jun, 3),
	Date(2020, Jul, 15),
	Date(2020, Aug, 12),
	Date(2020, Sep, 9),
	Date(2020, Oct, 7),
	Date(2020, Nov, 4),
	Date(2020, Dec, 2),
	Date(2020, Dec, 30),
	Date(2021, Jan, 27),
	Date(2021, Feb, 24),
	Date(2021, Mar, 24),
	Date(2021, Apr, 21),
	Date(2021, May, 19),
	Date(2021, Jun, 16)
]

my_date_format(d::Date) = 
	string(Dates.dayname(d), ", ", Dates.day(d), " ", Dates.monthname(d), " ", Dates.year(d))

function findnearest(A::AbstractArray, t)
	A = sort(A)

	for i in 1:length(A)
	   	A[i] < t && continue
		return A[i] # first element in A that is greater than today
	end	

	return nothing
end

function main()
	_next_on_call = findnearest(_start_dates, _today + Week(1))

	if isnothing(_next_on_call)
		println("We have no on-call data beyond $(sort(_start_dates)[end]).  Sorry about that.")
		return nothing
	end

	for i in _start_dates
		println(_today)
		println(_today + Week(1))
		if ( _today < i < _today + Week(1) ) || ( i == _today && Hour(_now) >= Hour(17) && Minute(_now) >= Minute(30) ) || ( i == _today + Week(1) && Hour(_now) <= Hour(20) && Minute(_now) < Minute(30) )
			println("Don't forget that you are currently on call.\n\n")
		end
	end

	println("You are next on call at 5:30 p.m. on $(my_date_format(_next_on_call)).\n\nThis on-call week will finish at 8:30 a.m. on $(my_date_format(_next_on_call + Week(1))).")

	return nothing

end

main()
