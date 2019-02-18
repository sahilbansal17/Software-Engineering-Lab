#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*@+allmacros -macrofcndecl@*/

/*@notfunction@*/
#define INCXY(x, y) (x)++; (y)++;

struct check_memory {
	int *check_int;
	/*@null@*/ char *check_char;
};

// get a 3-digit number input from the user
static void getCheckInt(/*@out@*/ struct check_memory* s);

// round the 3-digit number to hundreds in words 
static int roundThreeWords(struct check_memory* s);

void bufferOverflow(int *a);

void copy(/*@out@*/ /*@unique@*/ char *s, char * t);

typedef /*@abstract@*/ int* vector;

int zeroVector(vector a);

void swap (int a, int b);

int main () {

	int x = 0, y = 0;
	if ( x == 0 && y == 0) INCXY(x, y);

	struct check_memory* s;
	s = (struct check_memory*) malloc(sizeof(struct check_memory));

	if (!s) {
		printf("Unable to allocate memory to check_memory\n");
		return 0;
	}

	s->check_int = (int *) malloc(sizeof(int));
	if (s->check_int) {
		*s->check_int = 1234;
	}
	else {
		free(s);
		return 0;
	}

	if (1234 == *s->check_int) {
		printf("check_int has value 1234\n");
	}
	else {
		free(s->check_int);
		s->check_int = (int *)malloc(sizeof(int));
		if (s->check_int) {
			*s->check_int = 1234;
		}
	}

	getCheckInt(s);
	int res = roundThreeWords(s);
	if (res == 1) {
		if (s->check_char) {
			printf("Number rounded to hundreds in words: %s\n", s->check_char);
		}
		else {
			printf("Not a three digit number\n");
		}
	}

	// Handle the error 2 of memory leak
	free(s->check_int);
	free(s->check_char);
	if (s) free(s);

	return 0;
}

// get a 3-digit number input from the user
static void getCheckInt(/*@out@*/ struct check_memory* s) {
	/*@-usedef@*/
	(void) scanf("%d", s->check_int);
}

// round the 3-digit number to hundreds in words 
static int roundThreeWords(struct check_memory* s) {
	int n = *s->check_int;
	// assuming n to be a 3 digit number
	int dig1 = 0, dig2 = 0, dig3 = 0; 
	while (n > 0) {
		if (dig1 == 0) {
			dig1 = n % 10;
		}
		else if (dig2 == 0) {
			dig2 = n % 10;
		}
		else if (dig3 == 0) {
			dig3 = n % 10;
		}
		else {
			return 0;
		}
		n = n/10;
	}

	free(s->check_char);
	s->check_char = (char *) malloc(100*sizeof(char));
	if (s->check_char) {
		switch(dig3) {
			case 1: strcpy(s->check_char, "One hundred ");
					break;
			case 2: strcpy(s->check_char, "Two hundred ");
					break;
			case 3: strcpy(s->check_char, "Three hundred ");
					break;
			case 4: strcpy(s->check_char, "Four hundred ");
					break;
			case 5: strcpy(s->check_char, "Five hundred ");
					break;
			case 6: strcpy(s->check_char, "Six hundred ");
					break;
			case 7: strcpy(s->check_char, "Seven hundred ");
					break;
			case 8: strcpy(s->check_char, "Eight hundred ");
					break;
			case 9: strcpy(s->check_char, "Nine hundred ");
					break;
					// fall through case resolved
			case 0: strcpy(s->check_char, "Invalid number");
					return 0;
		}
		return 1;
	}
	return 0;
}


// The buffer overflow error was not reported
void bufferOverflow(int *a) {
	int i = 1000000000000000000;
	a[i] = 1;
}

// unique annotation fixes the dangerous aliasing error 
void copy(/*@out@*/ /*@unique@*/ char *s, char * t) {
	// Error: Dangerous Aliasing
	// parameter 1 to strcpy is declared unique
	// but maybe aliased externally by parameter 2
	strcpy(s, t);
}

int zeroVector(vector a) {
	int *a_prime = (int *) a;
	if (a_prime[0] == a[0] && a_prime[1] == a[1]) {
		return 1;
	}
	return 0;
}

void swap (int a, int b) {
	int c;
	c = a;
	a = b;
	b = c;
}