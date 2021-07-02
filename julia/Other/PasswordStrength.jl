function main()
    checks_per_second = 1
    
    # obtain password
    pass::Base.SecretBuffer = Base.getpass("Please enter your password a strength check")
    
    is_lower, is_numeric,  = false

    # wipe the secret buffer!
    Base.shred!(pass)
    
    return brute_length
end

main()
