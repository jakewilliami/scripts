#!/usr/bin/env bash
    #=
    exec julia --project="~/scripts/julia/Other/" --color=yes --startup-file=no -e 'include(popfirst!(ARGS))' \
    "${BASH_SOURCE[0]}" "$@"
    =#
	
#=
	e.g., ./IsPrimeFermat.jl 47
	e.g., ./IsPrimeFermat.jl 3599
	e.g., ./IsPrimeFermat.jl 2599
=#

using Dates

birthDay = parse(Int, ARGS[1])
birthMonth = parse(Int, ARGS[2])
birthYear = parse(Int, ARGS[3])


function main(birthDay::Integer, birthMonth::Integer, birthYear::Integer)
    fullBirthDate = Dates.Date(Dates.Day(birthDay), Dates.Month(birthMonth), Dates.Year(birthYear))
    
    everyJasonCounter = 0
    JasonCounter = 0
    everyDay = 0
    
    # if you are not born on the 13th of a month
    if ! isequal(birthDay, 13)
        # return "You are not born on the 13th day in a month.  Why are you running this programme?"
        for i in fullBirthDate:Dates.Day(1):Dates.today()
            everyDay = everyDay + 1
            if Dates.dayname(i) == "Friday" && isequal(Dates.day(i), 13)
                everyJasonCounter = everyJasonCounter + 1
            end
        end
        
        return "Though you are not born on the 13th day in a month, you have encountered $everyJasonCounter Friday the 13ths in the $everyDay days of your lifetime."
    end
    
    # find number of birthdays on friday the 13th
    for i in birthYear:Dates.year(Dates.today())
        if Dates.dayname(Dates.Date(Dates.Day(birthDay), Dates.Month(birthMonth), Dates.Year(i))) == "Friday"
            JasonCounter = JasonCounter + 1
            # println(Dates.Date(Dates.Day(birthDay), Dates.Month(birthMonth), Dates.Year(i)))
        end
    end
    
    # find number of friday the 13ths you have been encountered
    for i in fullBirthDate:Dates.Day(1):Dates.today()
        everyDay = everyDay + 1
        if Dates.dayname(i) == "Friday" && isequal(Dates.day(i), 13)
            everyJasonCounter = everyJasonCounter + 1
        end
    end
    
    
    # output
    return "You have had $JasonCounter Friday the 13th birthdays.  You have also encountered $everyJasonCounter Friday the 13ths in the $everyDay days of your lifetime."
end



output = main(birthDay, birthMonth, birthYear)
println(output)
