#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*@+allmacros -macrofcndecl@*/
#define INCXY(x, y) x++; y++;

struct check_memory {
	int *check_int;
	char *check_char;
};

// get a 3-digit number input from the user
void getCheckInt(struct check_memory* s);

// round the 3-digit number to hundreds in words 
int roundThreeWords(struct check_memory* s); 

void bufferOverflow(int *a);

void copy(/*@out@*/ char *s, char * t);

typedef /*@abstract@*/ int* vector;

int zeroVector (vector a);

void swap (int a, int b);

int main () {

	int x = 0, y = 0;

	// ERROR 1: A macro is defined in a way that may cause syntactic problems.
	// Macro parameters used without parantheses
	if (x == 0 && y == 0) INCXY(x, y);
	
	// ERROR 2: Memory leak, Fresh storage s not released before return
	struct check_memory* s;
	s = (struct check_memory*) malloc(sizeof(struct check_memory));

	if (!s) {
		printf("Unable to allocate memory to check_memory\n");
		return 0;
	}

	// ERROR 3: Type mismatch
	// s->check_int is of type (int *)
	// 1234 is of type integer

	// ERROR 4: Undefined value, rvalue s->check_int 
	// may not be initialized
	if (1234 == s->check_int) {
		printf("check_int has value 1234\n");
	}
	else {
		// ERROR 5: Memory leak, s->check_int was not released
		s->check_int = NULL;
		// ERROR 6: Dereferencing of NULL pointer
		*s->check_int = 1234;
	}

	// ERROR 7: Passed storage s contains 1 undefined field: check_char
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

	return 0;
}

void getCheckInt(struct check_memory* s) {
	// ERROR 1: Return value ignored
	scanf("%d", s->check_int);
}

int roundThreeWords(struct check_memory* s) {
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

	char *res = (char*) malloc(100*sizeof(char));
	if (res) {
		switch(dig3) {
			case 1: strcpy(res, "One hundred ");
					break;
			case 2: strcpy(res, "Two hundred ");
					break;
			case 3: strcpy(res, "Three hundred ");
					break;
			case 4: strcpy(res, "Four hundred ");
					break;
			case 5: strcpy(res, "Five hundred ");
					break;
			case 6: strcpy(res, "Six hundred ");
					break;
			case 7: strcpy(res, "Seven hundred ");
					break;
			case 8: strcpy(res, "Eight hundred ");
					break;
			case 9: strcpy(res, "Nine hundred ");
			case 0: strcpy(res, "Invalid number");
					// ERROR 1: Fall through case
					// No break at the end of prev. case

					// ERROR 2: Memory leak, 
					// memory not freed for res
					return 0;
		}
		free(s->check_char);
		s->check_char = (char *) malloc(100*sizeof(char));
		if (s->check_char) {
			// ERROR 3: Using possibly undefined storage
			// passed storage res not completely defined
			copy(s->check_char, res);
		}
		else {
			// ERROR 4: Memory leak,
			// memory not freed for res
			return 0;
		}
		free(res);
		return 1;
	}
	return 0;
}

// The buffer overflow error was not reported
void bufferOverflow(int *a) {
	int i = 1000000000000000000;
	a[i] = 1;
}

void copy(/*@out@*/ char *s, char * t) {
	// Error: Dangerous Aliasing
	// parameter 1 to strcpy is declared unique
	// but maybe aliased externally by parameter 2
	strcpy(s, t);
}

// Information hiding errors are also not reported
int zeroVector(vector a) {
	int *a_prime = (int *) a;
	if (a_prime[0] == a[0] && a_prime[1] == a[1]) {
		return 1;
	}
	return 0;
}

// ERROR: Function swap inconsistently redeclared to return int
// function modification inconsistent with specified interface

// Also, it had 2 args in declaration but 3 in definition
int swap (int a, int b, int c) {
	c = a;
	a = b;
	b = c;
	// Error: Problematic control flow
	// Path with no return in function declared to return int
	// execution may fall through without returning a 
	// meaningful result to the caller
}