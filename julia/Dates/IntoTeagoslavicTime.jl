#=
Ported from ../Other/.  Initial commit on 16th May, 2021.
=#

using Dates

# const TConversionMatrix = [
   # 100    0//1      0//1  1//1  0//1  0//1
   # 1//1  -12//1      0//1  0//1  0//1  0//1
   # 1//1    0//1  -1461//4  0//1  0//1  0//1
# ]
# const TConversionMatrix = [
 # 100.0    0.0     0.0   1.0  0.0  0.0
   # 1.0  -12.0     0.0   0.0  0.0  0.0
   # 1.0    0.0  -365.25  0.0  0.0  0.0
# ]

# 1 Gy = 100 Ty
# = 1200 Tm
# = 36525 Td

for T in (:TYear, :TMonth, :TWeek, :TDay)
    @eval struct $T <: DatePeriod
        value::Int
        $T(v::Number) = new(v)
    end
end

struct TDate <: TimeType
    instant::Dates.UTInstant{Day}
    Date(instant::Dates.UTInstant{Day}) = new(instant)
end

function validargs(::Type{TDate}, y::Int64, m::Int64, d::Int64)
    0 < m < 13 || return argerror("Month: $m out of range (1:12)")
    0 < d < daysinmonth(y, m) + 1 || return argerror("Day: $d out of range (1:$(daysinmonth(y, m)))")
    return argerror()
end

function TDate(y::Int64, m::Int64=1, d::Int64=1)
    err = validargs(Date, y, m, d)
    err === nothing || throw(err)
    return Date(UTD(totaldays(y, m, d)))
end
