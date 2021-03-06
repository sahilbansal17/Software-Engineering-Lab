#include <stdlib.h>
#include <stdio.h>
#include <string.h>

/*@null@*/ static int *f1 () {
	// create pointer for 'value' instead of declaring variable
	int *value = (int *)malloc(sizeof(int));
	if (value == NULL) {
		return NULL;
	}
	printf("Input Number: ");
	(void) scanf("%d", value);
	return value;
}

// observer annotation means that the value returned by f2 is safe and will not be modified
/*@observer@*/ static char* f2() {
	return "TESTING";
}

int main () {

	/*@only@*/ int *retvalue;
	char *str = (char *) malloc (sizeof(char));
	retvalue = f1();

	if (retvalue == NULL) {
		if (str != NULL) {
			free(str);
		}
		return(0);
	}

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