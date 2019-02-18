#include <stdio.h>
#include <stdlib.h>

int main () {

	int n, dig1 = 0, dig2 = 0, dig3 = 0;
	scanf("%d", &n);

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
			break;
		}
		n = n/10;
	}

	switch(dig3) {
		case 1: printf("One hundred ");
				break;
		case 2: printf("Two hundred ");
				break;
		case 3: printf("Three hundred ");
				break;
		case 4: printf("Four hundred ");
				break;
		case 5: printf("Five hundred ");
				break;
		case 6: printf("Six hundred ");
				break;
		case 7: printf("Seven hundred ");
				break;
		case 8: printf("Eight hundred ");
				break;
		case 9: printf("Nine hundred ");
		case 0: printf("Invalid number");
				return 0;
	}

	printf("+ %d\n", dig2*10 + dig1);

	return 0;
}