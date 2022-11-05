#include <stdio.h>

// Number of lines of input (data1.txt)
#define N 2000

// Length of input
int data_sz = 0;

int part1(int data[])
{
	int cnt = 0;
	for (int i = 1; i < data_sz; ++i) {
		if (data[i - 1] < data[i]) {
			++cnt;
		}
	}
	return cnt;
}

int part2(int data[])
{
	int cnt = 0;
	for (int i = 3; i < data_sz; ++i) {
		int a = data[i - 1] + data[i - 2] + data[i - 3];
		int b = data[i] + data[i - 1] + data[i - 2];
		if (a < b) {
			cnt += 1;
		}
	}
	return cnt;
}

int main()
{
	// Open file
	FILE *f;
	f = fopen("data1.txt", "r");

	if (f == 0) {
		printf("Could not open file.\n");
		return 1;
	}

	// Read file into array
	int data[N];
	data_sz = 0;

	while (!feof(f)) {
		int x = 0;
		int n = fscanf(f, "%d\n", &x);
		if (n == 1) {
			data[data_sz++] = x;
		}
	}

	// Close file
	fclose(f);

	// Display results!
	int part1_solution = part1(data);
	printf("Part 1: %d\n", part1_solution);
	int part2_solution = part2(data);
	printf("Part 2: %d\n", part2_solution);
}
