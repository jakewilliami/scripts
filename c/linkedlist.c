#include <stdio.h>
#include <stdlib.h>

// (1) Complete linked list node declaration below.
//     Do not change the name of the structure.
typedef struct node {
	int data;
	struct node *next;
} Node;

int main(void)
{
	struct node *head = NULL; // head points to the head of list
	struct node *tmp;
	
	// This for-loop will build a list
	for(int i = 0; i < 10; i++) {
		// (2) Use malloc() or calloc() to allocate memory for one node
		//     and let tmp point the the allocated memory.
		
		/* struct node *n = malloc(sizeof *n); */
		/* tmp = *n; */
		tmp = (Node *)malloc(sizeof(Node));
		
		

		// (3) Assign 100*(i+1) to data and let next point to NULL.
		tmp -> data = 100 * (i + 1);
		tmp -> next = NULL;
	
		// (4) Append tmp to the list pointed by head
		if (head == NULL) {
			head = tmp;
		} else {
			head -> next = tmp;
		}
	}
	
	struct node *rover = head;
	while(rover) {
		printf("%d ", rover->data);
		rover = rover->next;
	}
	printf("\n");
	
	return 0;
}
