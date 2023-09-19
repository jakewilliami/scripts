#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

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

size_t ndigits(size_t x)
{
	size_t n = 0;
	if (x == 0) return 1;
	if (x < 0) x = -x;

	while (x > 0) {
		x /= 10;
		n++;
	}

	return n;
}

// Get linear index from 2D coords
size_t linear_index(size_t row, size_t cols, size_t col)
{
	return row*cols + col;
}

void print_inds(Mat M)
{
	for (size_t i = 0; i < M.rows; i++) {
		for (size_t j = 0; j < M.cols; j++) {
			size_t k = linear_index(i, M.cols, j);
			printf("M[%zu, %zu] = M[%zu] = %zu\n", i, j, k, M.data[k]);
		}
	}
}

void print_mat(Mat M)
{
	size_t max_n = 0;
	for (size_t i = 0; i < M.rows; i++) {
		for (size_t j = 0; j < M.cols; j++) {
			size_t k = linear_index(i, M.cols, j);
			size_t x = M.data[k];
			size_t n = ndigits(x);
			if (n > max_n) max_n = n;
		}
	}

	printf("%zu×%zu Matrix{size_t}:\n", M.rows, M.cols);
	for (size_t i = 0; i < M.rows; i++) {
		for (size_t j = 0; j < M.cols; j++) {
			size_t k = linear_index(i, M.cols, j);
			size_t x = M.data[k];
			size_t n = ndigits(x);
			for (size_t s = 0; s < max_n - n + 1; s++) {
				printf(" ");
			}
			printf("%zu", x);
		}
		printf("\n");
	}
	printf("\n");
}

Mat rotl90(Mat A)
{
	Mat B = {0};
	B.rows = A.cols;
	B.cols = A.rows;
	B.data = (size_t *)malloc(A.rows * A.cols * sizeof(size_t));
	for (size_t i = 0; i < A.rows; i++) {
		for (size_t j = 0; j < A.cols; j++) {
			size_t a = linear_index(i, A.cols, j);
			size_t b = linear_index(A.cols - j - 1, B.cols, i);
			B.data[b] = A.data[a];
		}
	}
	return B;
}

Mat rotr90(Mat A)
{
	Mat B = {0};
	B.rows = A.cols;
	B.cols = A.rows;
	B.data = (size_t *)malloc(A.rows * A.cols * sizeof(size_t));
	for (size_t i = 0; i < A.rows; i++) {
		for (size_t j = 0; j < A.cols; j++) {
			size_t a = linear_index(i, A.cols, j);
			size_t b = linear_index(j, B.cols, A.rows - i - 1);
			B.data[b] = A.data[a];
		}
	}
	return B;
}

Mat rot180(Mat A)
{
	Mat B = {0};
	B.rows = A.rows;
	B.cols = A.cols;
	B.data = (size_t *)malloc(A.rows * A.cols * sizeof(size_t));
	for (size_t i = 0; i < A.rows; i++) {
		for (size_t j = 0; j < A.cols; j++) {
			size_t a = linear_index(i, A.cols, j);
			size_t b = linear_index(A.rows - i - 1, B.cols, A.cols - j - 1);
			B.data[b] = A.data[a];
		}
	}
	return B;
}

Mat rev_colwise(Mat A)
{
	Mat B = {0};
	B.rows = A.rows;
	B.cols = A.cols;
	B.data = (size_t *)malloc(A.rows * A.cols * sizeof(size_t));
	for (size_t i = 0; i < A.rows; i++) {
		for (size_t j = 0; j < A.cols; j++) {
			size_t a = linear_index(i, A.cols, j);
			size_t b = linear_index(i, B.cols, A.cols - j - 1);
			B.data[b] = A.data[a];
		}
	}
	return B;
}

Mat rev_rowwise(Mat A)
{
	Mat B = {0};
	B.rows = A.rows;
	B.cols = A.cols;
	B.data = (size_t *)malloc(A.rows * A.cols * sizeof(size_t));
	for (size_t i = 0; i < A.rows; i++) {
		for (size_t j = 0; j < A.cols; j++) {
			size_t a = linear_index(i, A.cols, j);
			size_t b = linear_index(A.rows - i - 1, B.cols, j);
			B.data[b] = A.data[a];
		}
	}
	return B;
}

Mat elementwise_mul(Mat A, Mat B)
{
	assert(A.rows == B.rows && A.cols == B.cols);
	Mat C = {0};
	C.rows = A.rows;
	C.cols = A.cols;
	C.data = (size_t *)malloc(A.rows * A.cols * sizeof(size_t));
	for (size_t i = 0; i < A.rows; i++) {
		for (size_t j = 0; j < A.cols; j++) {
			size_t k = linear_index(i, A.cols, j);
			C.data[k] = A.data[k] * B.data[k];
		}
	}
	return C;
}

size_t sum_mat(Mat M)
{
	size_t sum = 0;
	for (size_t i = 0; i < M.rows; i++) {
		for (size_t j = 0; j < M.cols; j++) {
			size_t k = linear_index(i, M.cols, j);
			sum += M.data[k];
		}
	}
	return sum;
}

int main()
{
	Mat A = init_mat(3, 3);
	Mat B = init_mat(3, 3);

	Mat C = elementwise_mul(A, B);
	print_mat(C);

	return 0;
}
