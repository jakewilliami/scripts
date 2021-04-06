import re

def inrange(min, max, val):
    return val <= max and val >= min

def validate(passport_dict):
    if 'byr' not in passport_dict.keys():
        return False
    elif not inrange(1920, 2002, int(passport_dict['byr'])):
        return False

    if 'iyr' not in passport_dict.keys():
        return False   
    elif not inrange(2010, 2020, int(passport_dict['iyr'])):
        return False

    if 'eyr' not in passport_dict.keys():
        return False
    elif not inrange(2020, 2030, int(passport_dict['eyr'])):
        return False

    if 'hgt' not in passport_dict.keys():
        return False
    elif not re.match("^[0-9]+(in|cm)$", passport_dict['hgt']):
        return False
    else:
        height = int(passport_dict['hgt'][:-2])
        units = passport_dict['hgt'][-2:]
        if units == "cm" and not inrange(150, 193, height):
            return False
        if units == "in" and not inrange(59, 76, height):
            return False

    if 'hcl' not in passport_dict.keys():
        return False
    elif not re.match("^#[0-9a-f]{6}$", passport_dict['hcl']):
        return False

    if 'ecl' not in passport_dict.keys():
        return False
    elif not re.match("amb|blu|brn|gry|grn|hzl|oth", passport_dict['ecl']):
        return False

    if 'pid' not in passport_dict.keys():
        return False
    elif not re.match("^[0-9]{9}$", passport_dict['pid']):
        return False


    return True


assert(validate({"pid":"087499704", "hgt":"74in", "ecl":"grn", "iyr":"2012", "eyr":"2030", "byr":"1980", "hcl":"#623a2f"}))
# assert(not validate({"eyr":"1972", "cid":"100", "hcl":"#18171d", "ecl":"amb", "hgt":"170", "pid":"186cm", "iyr":"2018", "byr":"1926"}))
# assert(not validate({"iyr":"2019", "hcl":"#602927", "eyr":"1967", "hgt":"170cm", "ecl":"grn", "pid":"012533040", "byr":"1946"}))
# assert(not validate({"hcl":"dab227", "iyr":"2012", "ecl":"brn", "hgt":"182cm", "pid":"021572410", "eyr":"2020", "byr":"1992", "cid":"277"}))
# assert(not validate({"hgt":"59cm", "ecl":"zzz", "eyr":"2038", "hcl":"74454a", "iyr":"2023", "pid":"3556412378", "byr":"2007"}))


f = open("input.txt", "r")
count = 0
for passport_data in f.read().split("\n\n"):
    passport = {}
    for feild_pairs in passport_data.split():
        key, val = feild_pairs.split(":")
        passport[key] = val
    if validate(passport):
        count += 1
print(count)
f.close()