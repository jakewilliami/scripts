import math

def find_seat_id(commands):
    xrange = (0, 127)
    yrange = (0, 7)

    for command in commands:
        if command == "F":
            new_max = math.floor((xrange[0] + xrange[1]) / 2)
            xrange = (xrange[0], new_max)
        elif command == "B":
            new_min = math.ceil((xrange[0] + xrange[1]) / 2)
            xrange = (new_min, xrange[1])
        elif command == "L":
            new_max = math.floor((yrange[0] + yrange[1]) / 2)
            yrange = (yrange[0], new_max)
        elif command == "R":
            new_min = math.ceil((yrange[0] + yrange[1]) / 2)
            yrange = (new_min, yrange[1])
    return xrange[0] * 8 + yrange[0]

f = open("input.txt", "r")
id_list = [find_seat_id(commands) for commands in f.readlines()]
id_list.sort()
print(id_list)

for x in range(11, 850):
    if x not in id_list:
        print(x)
        
f.close()