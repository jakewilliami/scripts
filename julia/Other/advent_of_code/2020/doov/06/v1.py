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
        count += len(votes)
    return count

print(getSum("test.txt"))
assert getSum("test.txt") == 11, 'test failed'