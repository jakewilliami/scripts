using Dates

_daysinmonth(m::Month, y::Year) = daysinmonth(y.value, m.value)

findfirst_tuesday(m::Month, y::Year) = 
    findfirst(i -> dayofweek(Date(Day(i), m, y)) == Tuesday, 1:_daysinmonth(m, y))

function penultimate_tuesday_date(m::Month, y::Year)
    ft = findfirst_tuesday(m, y)  # first Tuesday
    d = Date(Day(ft), m, y)
    n_tuesdays = daysofweekinmonth(d)
    tuesdays = ft:7:_daysinmonth(m, y)
    i = findfirst(x -> (n_tuesdays - dayofweekofmonth(Date(Day(x), m, y))) == 1, tuesdays)
    isnothing(i) && return nothing
    pt = Day(tuesdays[i])  # penultimate Tuesday
    return Date(pt, m, y)
end
penultimate_tuesday_date(d::Date) = penultimate_tuesday_date(Month(d), Year(d))

