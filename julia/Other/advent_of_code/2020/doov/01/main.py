
def getnum():
    f = open("input.txt", "r")
    numbers = [int(x) for x in f.readlines()]
    for i in numbers:
        for j in numbers:
            for k in numbers:
                if i == j or i == k or j == k:
                    continue
                if i + j + k == 2020:
                    return i * j * k
    f.close()
print(getnum())