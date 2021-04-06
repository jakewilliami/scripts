f = open("input.txt", "r")
rows = [line[:-1] for line in f.readlines()]

def _checklocation(x, y):
    global rows
    return rows[y][x] == "#"

x = 0
width = len(rows[0])
count = 0

# start at one to skip starting position
for y in range(1, len(rows) - 1):
    x = (x + 3) % width
    if _checklocation(x, y):
        count += 1

print(count)
