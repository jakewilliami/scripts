def getSum(file_string):
    f = open(file_string, "r")
    groups = [group.split('\n') for group in f.read().split("\n\n")]
    count = 0
    for group in groups:
        votes = {}
        for voter in group:
            for vote in voter:
                if vote in votes.keys():
                    votes[vote] += 1
                else:
                    votes[vote] = 1
        for key in votes.keys():
            print(key, votes[key])
            if votes[key] == len(group):
                count += 1
                
        print(len(group), '\n')
    return count

sum = getSum("/Users/jakeireland/Desktop/doov_advent_of_code/06/test.txt")
print(sum)
assert sum == 6, 'test failed'
