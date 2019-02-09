#include <stdio.h>
#include <stdlib.h>

int main () {

	int *p = NULL;

	int test;

	(void) scanf("%d", &test);

	if (test > 0) {
		p = &test;
	}
	else {
		/*
		
		the error was that we were directly assigning value to the address 
		pointed to by p but we first must check whether p is allocated some memory
	
		Error message as shown by splint:
		Dereference of null pointer p: *p

		*/
		if (p) {
			*p = 123;
		}
	}
	
	return 1;
}