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
		if (p) *p = 123;
	}
	
	return 1;
}