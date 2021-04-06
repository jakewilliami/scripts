def getOpLine(line):
    op, val = line.split()
    return (op, int(val), False)

def getAccumulator(op_lines):
    op_index = 0
    op_accumulator = 0
    while True:
        op, val, _ = op_lines[op_index]
        if op == "nop":
            op_lines[op_index] = (op, val, True)
            op_index += 1
        elif op == "acc":
            op_lines[op_index] = (op, val, True)
            op_accumulator += val
            op_index += 1
        elif op == "jmp":
            op_lines[op_index] = (op, val, True)
            op_index += val
        
        if op_index >= len(op_lines):
            return op_accumulator, True

        _, _, called = op_lines[op_index]
        if called:
            return op_accumulator, False

f = open("input.txt")
op_lines = [getOpLine(line) for line in f.readlines()]
acc, terminates = getAccumulator(op_lines)
print(acc, terminates)