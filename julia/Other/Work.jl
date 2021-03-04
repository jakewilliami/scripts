#!/usr/bin/env bash
    #=
    exec julia --project="$(realpath $(dirname $0))" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#

using Dates
using Printf: @sprintf

import Base.show

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
	Date(2021, Jun, 16),
    Date(2021, Jul, 7),
	Date(2021, Aug, 4),
	Date(2021, Sep, 1),
	Date(2021, Sep, 29),
	Date(2021, Oct, 27),
	Date(2021, Nov, 24),
	Date(2021, Dec, 22),
	Date(2022, Jan, 19),
	Date(2022, Feb, 16),
	Date(2022, Mar, 16),
	Date(2022, Apr, 13),
	Date(2022, May, 11),
	Date(2022, Jun, 8)
]

# struct Calendar
# 	day::Date
# 	days::Vector{Int}
#
# 	function Calendar()
# 		day = firstdayofmonth(today())
# 		return Calendar(year(day), month(day))
# 	end
#
# 	function Calendar(year::Dates.Year, month::Dates.Month)
# 		return Calendar(year.value, month.value)
# 	end
#
# 	function Calendar(year::Int, month::Int)
# 		day = Date(year, month, 1)
# 		days = vcat(fill(0, dayofweek(day) % 7), 1:dayofmonth(lastdayofmonth(day)))
# 		new(day, days)
# 	end
# end

function get_year_month_for_cal3(date::Date)
	last_date, next_date = date - Month(1), date + Month(1)
	last_month, next_month = month(last_date), month(next_date)
	year_last_month, year_next_month = year(last_date), year(next_date)
	prev_year_month, next_year_month = (year_last_month, last_month), (year_next_month, next_month)
	return prev_year_month, next_year_month
end
get_year_month_for_cal3() = get_month_year_for_cal3(today())

function get_enum_days(d::Date)
	return vcat(fill(0, dayofweek(d) % 7), 1:dayofmonth(lastdayofmonth(d)))
end
get_enum_days(y::Int, m::Int, d::Int) = get_enum_days(Date(y, m, d))

function get_enum_days_c3(d::Date)
	prev_year_month, next_year_month = get_year_month_for_cal3(d)
	_ds1 = get_enum_days(prev_year_month..., 1)
	_ds2 = get_enum_days(year(d), month(d), 1)
	_ds3 = get_enum_days(next_year_month..., 1)
	
	days_temp = (_ds1, _ds2, _ds3)
	max_length, max_month = findmax(length.([days_temp...]))
	
	days = []
	for (i, m) in enumerate(days_temp)
		if i ≠ max_month || length(m) ≠ max_length
			push!(days, vcat(m, fill(0, abs(max_length - length(m)))))
		end
	end
	
	insert!(days, max_month, days_temp[max_month])
	
	return Tuple(days)
end
get_enum_days_c3(y::Int, m::Int, d::Int) = get_enum_days_c3(Date(y, m, d))
get_enum_days_c3() = get_enum_days_c3(today())

struct Calendar3
	d::Date
	days::NTuple{3, Vector{Int}}
	
	function Calendar3()
		day = firstdayofmonth(today())
		return Calendar3(year(day), month(day))
	end
	
	function Calendar3(year::Dates.Year, month::Dates.Month)
		return Calendar3(year.value, month.value)
	end
	
	function Calendar3(year::Int, month::Int)
		d = Date(year, month, 1)
		
		# prev_year_month, next_year_month = get_year_month_for_cal3(Date(year, month, 1))
		# _ds1 = get_enum_days(prev_year_month..., 1)
		# _ds2 = get_enum_days(year, month, 1)
		# _ds3 = get_enum_days(next_year_month..., 1)
		
		days = get_enum_days_c3(Date(year, month))
		new(d, days)
	end
end

function center_str(str::String, fillstr::Union{String, Char}, width::Int)
	l = length(str)
	l > width && return str
	i = div(width - l, 2)
	return fillstr^i * str * fillstr^(width - l - i)
end
center_str(str::String, width::Int) = center_str(str, ' ', width)

format(day::Int) = day === 0 ? "   " : @sprintf "%3d" day

function show(io::IO, ::MIME"text/plain", C::Calendar3)
	# println(io, center("$(monthname(x.day)) $(year(x.day))", " ", 21))
	# print year
	_today = today()
	day_today = day(_today)
	days_in_month = daysinmonth(_today)
	
	printstyled(io, center_str(string(year(C.d)), (21*3) + (2*2)) * "\n") # 21 spaces in each month, and 2 * 2 spaces in between months
	
	# printstyled(io, center_str(, ))
	
	printstyled(io, (" Su Mo Tu We Th Fr Sa  " ^ 3) * "\n")
	
	these_weeks = NTuple{3, Int}[]
	for (index, days_zipped) in enumerate(zip(C.days...))
		push!(these_weeks, days_zipped)
		
		# we have one line of weeks
		if index % 7 == 0
			# iterate through number of months there are
			for i in 1:3
				# update number of days in month
				if i == 1
					days_in_month = daysinmonth(_today - Month(1))
				elseif i == 3
					days_in_month = daysinmonth(_today + Month(1))
				end
				
				# iterate through weeks of months
				for (i_m, monthly_week) in enumerate(getindex.(these_weeks, i))
					# iterate through days of week
					for (i_d, d) in enumerate(monthly_week)
						str = format(d)
						
						# spaces between months
						if i_m % 7 == 0
							str = str * " "
						end
						
						# println(i_m)
						# println(mod((mod1(index, 7) * 7) + i_m, days_in_month)) #+ (i_m % days_in_month))
						# println(mod1(((index ÷ 7)) + i_m, days_in_month))
						week_multiplier = index ÷ 7
						# println(mod(i_m * week_multiplier, days_in_month) + i_m)
						println((i_m * week_multiplier) + i_m)
						if i == 2 && (i_m * i_d) == day_today
							# printstyled(io, str, color = :reverse)
							# new line after last month
							# (i_m % 7 == 0 && i == 3) && println()
						else
							# printstyled(io, str)
							# new line after last month
							# (i_m % 7 == 0 && i == 3) && println()
						end
					end
				end
			end
			
			# reset this week's line
			these_weeks = NTuple{3, Int}[]
		end
	end
end

function format(d::Date)
	return string(Dates.dayname(d), ", ", Dates.day(d), " ", Dates.monthname(d), " ", Dates.year(d))
end

function findnearest(A::AbstractArray, t::Date)
	A = sort(A)
	
	for i in A
	   	i < t && continue
		return i # first element in A that is greater than today
	end

	return nothing
end

function main_text(io::IO)
	_today = today()
	_now = now()
	
	_next_on_call = findnearest(_start_dates, _today + Week(1))

	if isnothing(_next_on_call)
		printstyled(
			io,
			"We have no on-call data beyond $(sort(_start_dates)[end]).  Sorry about that.",
			color = :light_yellow
		)
		return nothing
	end

	printstyled(
		io,
		"You are next on call at ",
		bold = false,
		color = :normal
	)
	printstyled(
		io,
		"5:30 p.m. on $(format(_next_on_call)).\n\n",
		bold = true,
		color = :underline
	)
	printstyled(
		io,
		"This on-call week will finish at ",
		bold = false,
		color = :normal
	)
	printstyled(
		io,
		"8:30 a.m. on $(format(_next_on_call + Week(1))).\n",
		bold = true,
		color = :underline
	)

	for i in _start_dates
		if (i < _today < i + Week(1)) ||
			((i == _today) && (Hour(_now) ≥ Hour(17)) && (Minute(_now) ≥ Minute(30))) ||
			((i == _today + Week(1)) && (Hour(_now) ≤ Hour(20)) && (Minute(_now) < Minute(30)))
			printstyled(io, "\nDon't forget that you are currently on call.\n\n", color = :bold)
		end
	end

	return nothing

end
main_text() = main_text(stdout)

function main_cal(io::IO)
	
end
main_cal() = main_cal(stdout)

main_text()

display(Calendar3())
