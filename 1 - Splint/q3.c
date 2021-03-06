#include <stdlib.h>

struct check {
	char * sname;
	size_t ncount;
};

static int f1 (struct check *testc) {
	char *b = (char *) malloc(sizeof(char));
	if (b == NULL) return 0;
	printf("Input String: ");
	(void) scanf("%s", b);
	if (testc->sname) { // fixes the error 1
		free(testc->sname);
	}
	testc->sname = b; // error 1: memory not released before assignment
	testc->ncount = strlen(b);
	return 1;
}

static char * f2() {
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
	else if (c->sname != NULL) { // fixes the error 4
		free(c->sname);
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

// error 2 and error 3 can't be directly fixed without using annotations