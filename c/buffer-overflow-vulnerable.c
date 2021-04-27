// This is a piece of code that is vulnerable to a buffer overflow attack

// To underatand a buffer overflow attack (which falls into the category of "low-level memory exploits"), we must consider the situation as follows, and then we must recall how a compiled C programme is stored in memory:
// Say we are using C or some other low-level language to write a string to some piece of memory that is only a certain length.
// Writing something longer than that allocated memory then overwrites the later memory addresses (which is the fundamental cause of these exploits).
// Now let us quickly review how a compiled C programme is stored in memory:
// 
// +=============================+
// | 0xfff... (top of memory)    |
// +=============================+
// | kernel                      |
// +-----------------------------+
// | stack                       |
// +-----------------------------+
// | (stack grows downwards)     |
// |                             |
// | (heap grows upwards)        |
// +-----------------------------+
// | heap                        |
// +-----------------------------+
// | data                        |
// +-----------------------------+
// | text (read-only)            |
// +=============================+
// | 0x000... (bottom of memory) |
// +=============================+
//
// The text section of the memory of the programme is the actual compiled machine instructions (which is read-only);
// The data section is where uninitialised and initialised variables are stored;
// The heap is where you can allocate large things in memory (the heap grows up as required by the programme);
// The stack is where local variables are stored (and grows downward as required);
// And finally, the kernel is where command-line parameters that you pass to your programme are stored, and where environmental variables are stored.
//
// You can have buffer overflow in other areas, but today it will be in regard to these things.
// 
// When the calling function wants to make use of something, it adds its parameters that it is parsing onto the stack:
//
// 0x000...                     0xfff...
// +----------------------------+
// |        |   |   |   |   | . |
// |        | p | r | b | a | . |
// |        |   |   |   |   | . |
// +----------------------------+
//
// ... are functions, and you pass parameter a and b on the stack, at which point the functions can use both parameters.  
// r represents the return address, which is the place we go back to in our code once we have finished the function call
// p represents a reference to base pointer.
// The rest of the space is allocated for the buffer of the function call.
// 
// If we write something longer than our allocated buffer, we are going to go straight past the buffer, over the base pointer, and (crucially) over our return address.  And that is when we want to point back to something we shouldn't be doing, and that is how we exploit. 


#include <stdio.h>
#include <string.h>

int main (int argc, char** argv) {
	// Allocate some memory on the stack (in particular, we allocate a buffer that is 500 characters long)
	char buffer[500];
	// Copy a string to that allocated memory
	strcpy(buffer, argv[1]);
	
	// stop
	return 0;
}
