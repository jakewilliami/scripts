#include <stdlib.h> // atoi
#include <stdio.h> // printf

int main(int argc, char** argv) {
	int sum = 0;
	
    for (int counter = 1; argv[counter] != NULL; ++counter)     {
        sum += atoi(argv[counter]);
    }
	
    printf("%d", sum);	
	
    return 0;
}

