using DataFrames, GLM, Dates


# construct toy data
df = DataFrame(date = Date[Date(2021, 8, 20), Date(2021, 9, 20), Date(2021, 11, 20)], 
               worth = Float64[-72_501.0, -72_000.0, -69_891.0])

# as the linear model needs numerical data, we construct a data column
# in which we convert date to a numerical format
# rather than epoch, we will use the number of Rata Die days since epoch
# as it is simple enough as we are not working with super specific
# times.  If time matters a lot, I would suggest using `datetime2unix` 
# instead of `datetime2rata`
df.date_rata = Int[datetime2rata(d) for d in df.date]
df.date_unix = Float64[datetime2unix(DateTime(d)) for d in df.date]

# construct a linear model, with the formula
# of the form `@formula(y ~ x)`
model = fit(LinearModel, @formula(date_rata ~ worth), df)

# fit the model to the equation of a line:
# y = m⋅x + c
# so `coef(model)` in this case returns `(c, m)`
y_intercept, gradient = coef(model)

# as out formula is of the form `y ~ x` ≡ `date ~ worth` then solving 
# for when worth == 0 (i.e., when the toy person with the toy data is
# not in debt, we set x == 0, meaning we get
# `y = c`
# so y at x == 0 is `first(coef(model))`
rata2datetime(round(Int, y_intercept))


#=
julia> rata2datetime(round(Int, first(coef(fit(LinearModel, @formula(date_rata ~ worth), df)))))
2028-04-12T00:00:00

julia> unix2datetime(first(coef(fit(LinearModel, @formula(date_unix ~ worth), df))))
2028-04-11T20:41:21.780
=#
