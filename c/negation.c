# include <stdio.h>
# include <stdint.h>

// This is an interesting way of negating x (i.e., x becomes -x)
// Something about bitwise and with negative zero?
int main(int argc, char *argv[]) {
	double x = 69.0;
	double mz = -0.0;
	uint64_t r = *(uint64_t*)&x ^ *(uint64_t*)&mz;

	printf("%lf\n", *(double*)&r);

	return 0;
}
