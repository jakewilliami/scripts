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

def tryChangeOp(op_lines, op_index):
    new_op_lines = op_lines.copy()
    op, val, _ = new_op_lines[op_index]
    if op == "nop":
        new_op_lines[op_index] = ("jmp", val, False)
    elif op == "jmp":
        new_op_lines[op_index] = ("nop", val, False)
    return getAccumulator(new_op_lines)

def mutateOps(op_lines):
    op_index = 0
    for op_index in range(len(op_lines)):
        op, _, _ = op_lines[op_index]
        if op == "acc":
            continue
        else:
            acc, terminates = tryChangeOp(op_lines, op_index)
            if terminates:
                return acc, terminates
        

f = open("input.txt")
op_lines = [getOpLine(line) for line in f.readlines()]
acc, terminates = mutateOps(op_lines)
print(acc, terminates)