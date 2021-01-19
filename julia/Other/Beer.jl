using DataFrames, CSV, DataFramesMeta

# MAX AT UNI, 2020

datafile = joinpath("/Volumes", "NO NAME", "my-data", "economy", "bnz", "csv-exports", "other", "Max-Ireland-22FEB2020-to-6NOV2020.csv")
datafile2 = joinpath("/Volumes", "NO NAME", "my-data", "economy", "bnz", "csv-exports", "other", "Flat-Rent-22FEB2020-to-6NOV2020.csv")

# payees_of_interest = (,)

df = CSV.read(datafile, DataFrame)
df2 = CSV.read(datafile2, DataFrame)

# remove missing payees
function remove_missing(df::DataFrame)
    df = @where(df, !ismissing(:Payee))
    replace!(df.Payee, missing => "Mr. Nobody")
    df.Payee = convert(Array{String, 1}, df.Payee)
    return df
end

df = remove_missing(df)
df2 = remove_missing(df2)

# show unique payees
# show(stdout, "text/plain", unique(df.Payee))

get_total(df::DataFrame, payees::Tuple) =
    sum(@where(df, :Payee .∈ Ref(payees)).Amount)
get_total(df::DataFrame, payee::String) =
    sum(@where(df, :Payee .== payee).Amount)
get_total(df1::DataFrame, df2::DataFrame, payee) =
    get_total(df1, payee) + get_total(df2, payee)

jj = get_total(df, df2, ("J J MURPHY & CO", "JJ MURPHY & CO")) # 701.50
liq = get_total(df, df2, "DISCOUNT LIQUOR CENT") # 1037.77
vuw = get_total(df, df2, ("MILK & HONEY CAFE", "THE LAB", "Wishbone", "MAKI MONO KELBURN", "MAKI MONO")) # 534.88
mini_mart = get_total(df, df2, ("INVINCIBLE MINI MART", "Invincible Mini Mar")) # 685.34
