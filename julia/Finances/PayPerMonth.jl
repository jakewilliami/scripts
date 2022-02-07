using Formatting

const MONTHLY_PAY = error("not implemented")
const WELLBEING_ALLOWANCE = error("not implemented")
const WEEK_DIVISOR = 52//12

format_money(n::Number) = '$' * format(round(n, digits = 2), commas = true)

function main(io::IO)
    p = MONTHLY_PAY - WELLBEING_ALLOWANCE
    println(io, format_money(WELLBEING_ALLOWANCE), " ⟶  Technology")
    println(io, format_money(p), " ⟶  Aside")
    p = Float64(p / WEEK_DIVISOR)
    println(io, format_money(p), " ⟶  Main") 
end
main() = main(stdout)

main()
