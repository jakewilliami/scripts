using DataFrames, CSV, DataFramesMeta

# JAAKE AT UNI, 2020

datafile = joinpath("/Volumes", "NO NAME", "my-data", "economy", "bnz", "csv-exports", "main-account", "J.-W.-Ireland-1JAN2020-to-31DEC2020.csv")

# payee_of_interest = ("",)
payee_of_interest = ("MILK & HONEY CAFE", "WILLI'S KITCHEN", "KELBURN CAFE", "BROOKLYN DELI LIMITE", "THE LAB", "ENIGMA CAFE", "Enigma Cafe", "Wishbone", "CAFE NEO", "SUTTO CAFE", "CAMBODIA BAKERY AND", "BIRDWOODS CAFE")

df = CSV.read(datafile, DataFrame)

# show unique payees
# show(stdout, "text/plain", unique(df.Payee))

df2 = @where(df, :Payee .∈ Ref(payee_of_interest))
total_spent = sum(df2.Amount)
n_coffees_per_week = abs(round(Int, (total_spent / 52) / 4.5))
# println(total_spent, " => ", n_coffees_per_week)

# sum(@where(df, :Payee .∈ Ref(("Harbour City Fu", "STUDsYLINK (MSD)"))).Amount)
sum(@where(df, :Payee .∈ Ref(("MILK & HONEY CAFE", ))).Amount)
