#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct check {
	char * sname;
	size_t ncount;
};

static int f1 (struct check *testc) {
	char *b = (char *) malloc(sizeof(char));
	if (b == NULL) return 0;
	printf("Input String: ");
	(void) scanf("%s", b);
	testc->sname = b;
	testc->ncount = strlen(b);
	return 1;
}

static char * f2() {
	char * str = (char *) malloc(sizeof(char));
	if (str != NULL) {
		strcpy(str, "TESTING");
		return str;
	}
	/*@null@*/
	return NULL;
}

int main () {

	struct check * c = (struct check *) malloc (sizeof(struct check));
	if (c == NULL) {
		exit(0);
	}

	/*@out@*/
	if (f1(c) == 0) {
		if(c->sname != NULL) {
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