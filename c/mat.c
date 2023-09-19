#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

typedef struct {
	size_t rows;
	size_t cols;
	size_t *data;
} Mat;

Mat init_mat(size_t rows, size_t cols)
{
	Mat M = {0};
	M.rows = rows;
	M.cols = cols;
	M.data = (size_t *)malloc(M.rows * M.cols * sizeof(size_t));
	for (size_t i = 0; i < M.rows * M.cols; i++) {
		M.data[i] = i + 1;
	}
	return M;
}

size_t ndigits(size_t x) {
	size_t n = 0;
	if (x == 0) return 1;
	if (x < 0) x = -x;

	while (x > 0) {
		x /= 10;
		n++;
	}

	return n;
}

void print_mat(Mat M)
{
	size_t max_n = 0;
	for (size_t i = 0; i < M.rows; i++) {
		for (size_t j = 0; j < M.cols; j++) {
			size_t k = i*(M.cols) + j;
			size_t x = M.data[k];
			size_t n = ndigits(x);
			if (n > max_n) max_n = n;
		}
	}

	printf("%zu×%zu Matrix{size_t}:\n", M.rows, M.cols);
	for (size_t i = 0; i < M.rows; i++) {
		for (size_t j = 0; j < M.cols; j++) {
			size_t k = i*(M.cols) + j;
			size_t x = M.data[k];
			size_t n = ndigits(x);
			for (size_t s = 0; s < max_n - n + 1; s++) {
				printf(" ");
			}
			printf("%zu", x);
		}
		printf("\n");
	}
}

Mat rotr90(Mat ) {}

 149 function·rotr90(A::AbstractMatrix)
   1 ····ind1,·ind2·=·axes(A)
   2 ····B·=·similar(A,·(ind2,ind1))
   3 ····m·=·first(ind1)+last(ind1)
   4 ····for·i=ind1,·j=axes(A,2)
   5 ········B[j,m-i]·=·A[i,j]
   6 ····end
   7 ····return·B
   8 end



int main()
{
	Mat M = init_mat(3, 3);
	print_mat(M);
	free(M.data);
	return 0;
}
