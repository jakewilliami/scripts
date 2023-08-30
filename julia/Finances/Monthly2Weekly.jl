# Given a monthly payment, tell me what the equivalent pay is weekly

function _monthly_to_weekly_round(v::Real)
    return round(v, RoundUp, digits = 2)
end

function monthly_to_weekly1(monthly::Real)
    # Multiply by 12 months in a year;
    # divide by 52 weeks in a year
    v =(monthly * 12) / 52
    return _monthly_to_weekly_round(v)
end

function monthly_to_weekly2(monthly::Real)
    # Multiply by 12 monthy in a year;
    # divide by the number of weeks in an average year
    # Note: 1461 / 28 = 365.25 / 7
    v = (monthly * 12) / (1461 / 28)
    return _monthly_to_weekly_round(v)
end

function monthly_to_weekly3(monthly::Real)
    # There are approximately 4.33 weeks in a month
    # Note: 13 / 3 = 4.33...
    v = monthly / (13/3)
    return _monthly_to_weekly_round(v)
end

function monthly_to_weekly4(monthly::Real)
    # Divide by average number of days in a month;
    # multiply by 7 days in a week
    # Note: 487 / 16 = 30.4375 = (3*(365 / 12) + (366 / 12)) / 4
    v = (monthly / (487 / 16)) * 7
    return _monthly_to_weekly_round(v)
end


println(monthly_to_weekly1(55))
println(monthly_to_weekly2(55))
println(monthly_to_weekly3(55))
println(monthly_to_weekly4(55))
