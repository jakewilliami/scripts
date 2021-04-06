f = open("input.txt", "r")
rows = [line[:-1] for line in f.readlines()]

def _checklocation(x, y):
    global rows
    return rows[y][x] == "#"

def _checkslope(xstep, ystep):
    x = 0
    y = ystep
    count = 0

    # start at one to skip starting position
    while y < len(rows):
        x = (x + xstep) % len(rows[0])
        if _checklocation(x, y):
            count += 1
        y += ystep
    return count

result = _checkslope(1, 1) * _checkslope(3, 1) * _checkslope(5, 1) * _checkslope(7, 1) * _checkslope(1, 2)
# result = _checkslope(3, 1)
print(result)