#include <stdlib.h>

static int *f1 () {
	int value;
	printf("Input Number: ");
	(void) scanf("%d", &value);
	return &value; /* error 1: stack-allocated storage &value reachable from return value
					after the function returns the memory for 'value' will be freed automatically
					since it is part of stack-allocated storage
					so a dangling reference will be remaining
					*/
}

static char* f2() {
	return "TESTING"; /* error 2: observer storage is transferred to a non-observer reference
						since the function has a return type of 'char *'
						its value can be modified where f2() is being called
						*/
}

int main () {

	int *retvalue;
	char *str = (char *) malloc (sizeof(char));
	retvalue = f1();

	if (*retvalue > 0 && str != NULL) {
		strcpy(str, f2()); /* error 3: new fresh storage (type char *) passed as implicitly temp
							(not released) : f2()
							since we do not store the (char *) value returned by f2() anywhere
							its getting leaked
							*/
		printf("String : %s \n", str);
	}

	if (str != NULL) {
		free(str);
	}
	if (retvalue != NULL) {
		free(retvalue);
	}
	return(1);
}