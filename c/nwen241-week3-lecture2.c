// Pointers

int main(int argc, char *argv[]) {
	// Declaration
	int a = 1;
	int *x = NULL; // make pointer point to a safe location (NULL)
	// // Null pointer literal/constant to non-existent address
	
	// --------

	// Assignment
	x = &a; // "address of a"

	// --------

	// Example
	int a = 1;
	int b = 5;
	int *x;
	x = &a; // What is the value of x?
	// // The value of x is whatever the address of a is
	*x = *x + 1; // a = ?; b = ?
	// // *x is the value of whatever x points to.  x points to a, and a has a value 1, and 1 + 1 is 2, so we assign 2 to whatever x is pointing to.  x is pointing to a, so a becomes 2.
	// // You only need the * to dereference a pointer
	b = *x;
	// // What is the value of b?
	// // x points to a, which has value 2, so therefore b changes to the value 2.
	
	// --------
	
	// Usage of pointers
	// // 1. Provide an alternate means of accessing information stored in arrays
	// // // Arrays are actually just pointers.  Arrays in C are pointed to, i.e., the variable that you declare for the array is actually a *fixed pointer* to the first array element
	// // // Example:
	int z[10] = {1, 2, 3};
	// // // z is a fixed pointer, it points to the address of the first element `z[0]`.  In other words, `z == &z[0]`.
	
	// --------

	// Pointer Arithmetic
	// // Suppose you have a declaration
	data_type *name;
	// // If you perform `name + k` it is evaluated as `name + k*sizeof(data_type)`
	// // If you perform `name - k` it is evaluated as `name - k*sizeof(data_type)`
	// // // In general, `z + 1 == &z[i]`

	// --------

	// Pointers and Arrays
	// // Array elements are usually accessed using [] (with index)
	// // Pointers can...
	int z[10], *ip;
	ip = &z[0];
	ip++;

	// --------

	// Example of Pointer Arithmetic
	// // Assume a short variable is 2 bytes, and a pointer variable is 4 bytes
	short a[10] = {5, 10, 15, ...};
	short *pa;
	int i = 5;
	pa = &a;

	// // The array looks like:
	// //
	// // 		a
	// // 	   ----
	// // 640	5
	// // 642	10
	// // 644	15
	// // ...	...
	// // 660	50
	// //
	// // // Notice that a has length 10, and the pointer goes up in 2s, because shorts are 2 bytes.
	// // // pa has the address 700, and points to memory address 640.
	// // // pa + 1 != 641
	// // // Recall: pa + 1 == pa + 1*sizeof(short) == pa + 2 == 642
	// // // Likewise: pa + 3 == pa + 3*sizeof(short) == pa + 6 == 646
	// // // And: pa + 5 == pa + 5*sizeof(short) == pa + 10 == 650
	
	// // // What about `*pa + 1`?
	// // // `pa` points to a, so `*pa` is 5.  So *pa + 1 == 5 + 1 == 6.
	// // // And `*(pa + 1)`?
	// // // *(pa + 1) == *(pa + 1*sizeof(short)) == *(pa + 2) == *(642) == 10
	// // // In plain English: *(pa + 1) == "the value at address pa + 1"

	// // // What about `pa[2]`?
	// // // This is just regular array accessing.

	// --------
	
	// Traversing arrays using Pointers
	// // The usual way to iterate over arrays:
	int a[] = {...};
	int len = sizeof(a)/sizeof(int);
	for(int i = 0; i < len; i++) {
		/* do something about a[i] */
	}

	// // But using pointers:
	int a[] = {...};
	int len = sizeof(a)/sizeof(int);
	for(int *ip = a; ip < a + len; ip++) {
		/* do something about *ip */
	}

	// --------

	// Note on operator precedence:
	// // ++ and -- *postfix* operators have level 1 precedence, i.e., same as (), [], ->, and .
	// // Notably, a++ is subtly different form ++a.
	// // Suppose we have
	a = b++;
	// // This is actually equivalent to the following:
	a = b;
	b = b + 1;
	// // Whereas prefix:
	a = ++b;
	// // Is equivalent to:
	b = b + 1;
	a = b;
	// So keep this in mind regarding pointer arithmetic.

	// --------
	
	// Increment and Indirection Together
	// // Suppose we have
	int *ip;
	int i;
	// // What does `i = *ip++` mean?
	// // // Since postfix ++ has higher precedence than *, the RHS expression evaluates to `*(ip++)`, which means
	i = *ip; ip = ip + 1;
	// // But (*ip)++ is different

	// --------
	
	// Pointer Types
	// // Pointer variables are generally of the same size, but it is *inappropriate* to assign an address of one type of pointer variable to a different type of pointer variable.
	// // Example:
	int v = 101;
	float *p = &v; // generally results in a warning.  You cannot let a float pointer point to an integer.  It is not illegal, as there *may* be some valid reasons to do this
	
	// // Casting pointers
	int v = 101;
	float *p = (float *) &v; // this will get rid of the warning.
	
	// // General (void_ pointer
	// // A void * is considered to be a *general pointer*, it can point to any tupe of pounter variable
	// No cast is needed 
	// // Example:
	int v = 101;
	void *G = &V; // No warning
	float *p = G; // No warning, still unsafe
	
	
	// --------
	
	return 0;
}


