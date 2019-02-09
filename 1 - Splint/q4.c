#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct check {
	char * sname;
	size_t ncount;
};

// the annotation "out" fixes the error 3 as now the parameter of the function
// can contain undefined fields
static int f1 (/*@out@*/ struct check *testc) {
	char *b = (char *) malloc(sizeof(char));
	if (b == NULL) return 0;
	printf("Input String: ");
	(void) scanf("%s", b);
	// the error 1 no longer exists as paramter testc can have undefined fields
	testc->sname = b; // error 1: memory not released before assignment
	testc->ncount = strlen(b);
	return 1;
}

// the annotation "null" before the function return type fixes the error 2
// as now NULL value can be returned by the function
/*@null@*/ static char * f2() {
	char * str = (char *) malloc(sizeof(char));
	if (str != NULL) {
		strcpy(str, "TESTING");
	}
	return str; // error 2: possibly null storage str returned as non-null: str 
}

int main () {

	struct check * c = (struct check *) malloc (sizeof(struct check));
	if (c == NULL) {
		exit(0);
	}

	if (f1(c) == 0) { // error 3: passed storage *c contains 2 undefined fields
		if(c->sname != NULL) {
			free(c->sname);
		}
	} // error 4: storage c->sname is released in one path, but live in another
	else { // fixes error 4
		if ((c->sname) != NULL) {
			free(c->sname);
		}
	}

	c->sname = f2();
	if (c->sname != NULL) {
		c->ncount = strlen(c->sname);
	}

	if (c != NULL) {
		free (c);
	}
	return 1;
}