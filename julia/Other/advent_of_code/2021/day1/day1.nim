import std/[sugar, strformat]
from std/strutils import parseInt

proc parseInput(dataFile: string): seq[int] = 
  let data = collect(newSeq):
    for line in dataFile.lines:
      parseInt(line)
  
  return data

proc part1(data: seq[int]): int =
  var cnt = 0
  for i in 1 .. data.len - 1:
    if data[i - 1] < data[i]:
      cnt += 1
  return cnt

proc part2(data: seq[int]): int =
  var cnt = 0
  for i in 3 .. data.len - 1:
    let a = data[i - 1] + data[i - 2] + data[i - 3]
    let b = data[i] + data[i - 1] + data[i - 2]
    if a < b:
      cnt += 1
  return cnt

proc main() =
  # parse input
  let data = parseInput("data1.txt")
  
  # part 1
  let part1Solution = part1(data)
  echo(fmt"Part 1: {part1Solution}")
  
  # part 2
  let part2Solution = part2(data)
  echo(fmt"Part 2: {part2Solution}")

main()
