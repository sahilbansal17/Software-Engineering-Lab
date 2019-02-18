#include <stdio.h>
#include <stdlib.h>

int main () {

	int *p = NULL;

	if (123 == *p) {
		printf("Referencing allocated pointer");
	}
	
	return 0;
}