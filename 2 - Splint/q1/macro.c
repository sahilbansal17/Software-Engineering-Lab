#include <stdio.h>
#include <stdlib.h>

#define square(x) x*x
#define add(x) x+x

int main () {

	int x = 2, y = 3;
	printf("%d", square(x++));

	return 0;
}