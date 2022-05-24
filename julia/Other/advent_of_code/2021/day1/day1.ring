Load "stdlib.ring"

func main
	data = parseInput("data1.txt")
	
	# Part 1
	part1Solution = part1(data)
	see "Part 1: " + part1Solution + nl
	
	# Part 2
	part2Solution = part2(data)
	see "Part 2: " + part2Solution + nl


func parseInput datafile
	data = new list ([])
	fp = Fopen(datafile, "r")
	
	while true
		# No number in the input data should be greater than 16 characters
		line = fgets(fp, 16)
		
		# Break if we have already reached the end of the file
		if Feof(fp)
			break
		ok
		
		# Break if this is an empty (or new) line
		if len(trim(line)) = 0 || trim(line) = nl
			continue
		ok
		
		# Parse the line as a number and append to the list
		n = number(line)
		data.add(n)
	end
	
	Fclose(fp)
	
	return data


func part1 data
	cnt = 0
	
	for i = 2 to len(data)
		if data[i - 1] < data[i]
			cnt++
		ok
	next
	
	return cnt


func part2 data
	cnt = 0
	
	for i = 4 to len(data)
		a = data[i - 1] + data[i - 2] + data[i - 3]
		b = data[i] + data[i - 1] + data[i - 2]
		if a < b
			cnt++
		ok
	next
	
	return cnt

