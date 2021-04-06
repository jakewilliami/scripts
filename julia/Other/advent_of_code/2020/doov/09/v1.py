f = open("input.txt", "r")

def isSum(numbers, i):
    number = numbers[i]
    for j in range(max(i-25, 0), i):
        addend_1 = numbers[j]
        for k in range(max(i-25, 0), i):
            addend_2 = numbers[k]
            if j == k:
                continue
            else:
                if addend_1 + addend_2 == number:
                    return (addend_1, addend_2, number)

    return False
                    

numbers = [int(line) for line in f.readlines()]
for i in range(25, len(numbers)):
    print(isSum(numbers, i))
    if not isSum(numbers, i):
        print(numbers[i])
        break