# include <stdio.h>
# include <stdint.h>

// This is an interesting way of negating x (i.e., x becomes -x)
// Something about bitwise and with negative zero?
int main(int argc, char *argv[]) {
/* int main(int argc, char** argv) */
	// first element is invalid, so we start counting from one
	for (int i = 1; i < argc; ++i){
		// https://stackoverflow.com/questions/13424265/convert-a-char-to-double/13424364
		/* double x = atof(argv[i]); */
		/* double x = (double)argv[i]; */
		double x = strtod(argv[i], NULL);
		// do bitwise black magic
		double mz = -0.0;
		uint64_t r = *(uint64_t*)&x ^ *(uint64_t*)&mz;
		
		// print negation
		printf("%lf\n", *(double*)&r);
	}

	// We need a return value
	return 0;
}
