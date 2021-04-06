def xor(a, b):
    return (a and not b) or (b and not a)

f = open("input.txt", "r")

count = 0

for rows in f.readlines():
    limits, char, password = rows.split(" ")
    min, max = [int(x) for x in limits.split("-")]
    char = char[:-1]
    password = password[:-1]
    if xor(password[min - 1] == char, password[max - 1] == char):
        # print("[" + password[0] + "]", password)
        count += 1

print(count)
    
    
