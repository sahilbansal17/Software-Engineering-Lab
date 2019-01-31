#include <stdlib.h>
#include <stdio.h>
#include <string.h>

static int *f1 () {
	int value;
	printf("Input Number: ");
	(void) scanf("%d", &value);

	return &value;
}

/*@observer@*/ static char* f2() {
	return "TESTING";
}

int main () {

	int *retvalue;
	char *str = (char *) malloc (sizeof(char));
	retvalue = f1();
	if (*retvalue > 0 && str != NULL) {
		strcpy(str, f2());
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