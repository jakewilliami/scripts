f = open("input.txt", "r")

def isSum(numbers, i, distance):
    number = numbers[i]
    for j in range(max(i-distance, 0), i):
        addend_1 = numbers[j]
        if addend_1 > number:
            continue
        else:
            for k in range(max(i-distance, 0), i):
                addend_2 = numbers[k]
                if addend_2 > number or j == k:
                    continue
                else:
                    if addend_1 + addend_2 == number:
                        return (addend_1, addend_2, number)

    return False
                    
def getNonSum(numbers):
    for i in range(25, len(numbers)):
        if not isSum(numbers, i, 25):
            return numbers[i]

def getContiguousSet(numbers):
    non_sum = getNonSum(numbers)
    for start in range(0, len(numbers)):
        if numbers[start] > non_sum:
            continue
        for end in range(start + 1, len(numbers)):
            contiguous_set = [numbers[i] for i in range(start, end)]
            contiguous_set_sum = sum(contiguous_set)
            if contiguous_set_sum == non_sum:
                return contiguous_set
            elif contiguous_set_sum > non_sum:
                break

    

numbers = [int(line) for line in f.readlines()]
contiguous_set = getContiguousSet(numbers)
print(max(contiguous_set) + min(contiguous_set))