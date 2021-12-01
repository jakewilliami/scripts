package main

import (
	"fmt"
	"os"
	"bufio"
	"strconv"
)

func parseInput(dataFile string) []int {
	// open file pointer
	file, err := os.Open(dataFile)
	if err != nil {
		panic(err)
	}
	defer file.Close()
	
	// start buffer scanner
	data := []int{}
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		value, _ := strconv.ParseInt(line, 10, 0)
		data = append(data, int(value))
	}
	if err := scanner.Err(); err != nil {
		panic(err)
	}
	
	// return list of integets
	return data
}

func part1(data []int) int {
	cnt := 0
	for i := 1; i < len(data); i++ {
		if data[i - 1] < data[i] {
			cnt += 1
		}
	}
	return cnt
}

func part2(data []int) int {
	cnt := 0
	for i := 3; i < len(data); i++ {
		a := data[i - 1] + data[i - 2] + data[i - 3]
		b := data[i] + data[i - 1] + data[i - 2]
		if a < b {
			cnt += 1
		}
	}
	return cnt
}

func main() {
	// parse input
	data := parseInput("data1.txt")
	
	// part 1
	part1Solution := part1(data)
	fmt.Printf("Part 1: %d\n", part1Solution)
	
	// part 2
	part2Solution := part2(data)
	fmt.Printf("Part 2: %d\n", part2Solution)
}
