def validate(passport_fields):
    if 'byr' not in passport_fields:
        return False
    if 'iyr' not in passport_fields:
        return False
    if 'eyr' not in passport_fields:
        return False
    if 'hgt' not in passport_fields:
        return False
    if 'hcl' not in passport_fields:
        return False
    if 'ecl' not in passport_fields:
        return False
    if 'pid' not in passport_fields:
        return False
    return True

f = open("input.txt", "r")
count = 0
for passport_data in f.read().split("\n\n"):
    passport = []
    for feild_pairs in passport_data.split():
        key, _ = feild_pairs.split(":")
        passport.append(key)
    if validate(passport):
        count += 1
print(count)