#include <stdio.h>
#include <stdlib.h>

int main () {

	char *s = (char *) malloc(10*sizeof(char));	

	if (s) {
		strcpy(s, "Hello world");
	}

	if (strcmp(s, "Bye world") == 0) {
		printf("I do not want to free it all...\n");
	}
	else {
		printf("I am still alive...\n");
	}

	return 0;
}