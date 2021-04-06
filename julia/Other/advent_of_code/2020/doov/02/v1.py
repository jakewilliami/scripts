f = open("input.txt", "r")

count = 0

for rows in f.readlines():
    limits, char, password = rows.split(" ")
    min, max = [int(x) for x in limits.split("-")]
    char = char[:-1]
    password = password[:-1]

    charcount = password.count(char)
    if charcount >= min and charcount <= max:
        count += 1

print(count)
    
    
