using Base64

pass = Base.getpass("Please enter your password in order to encode it")

enc = Base64.base64encode(pass)

# wipe the secret buffer!
Base.shred!(pass)

println(String(enc))
