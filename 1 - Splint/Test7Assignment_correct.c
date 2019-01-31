#include<stdio.h>
#include<stdlib.h>
//#include<q4.h>
#include<string.h>
#define add(x) (x) + (x)

typedef /*@abstract@*/ char *StringData;

/*@checkedstrict@*/int ct = 5;

int main() {

    printf("Hello");

    return 0;

}

int* q1(/*@null@*/int* s) {
  
    return s;
}

void q2_1(/*@unused@*/ int* s) {}

void q2(/*@out@*/int *s) {
     q2_1(s);
}

void q3() {
  char c;
  int i = 44;
  c = (char) i;
}

void q4(StringData p) {
    /*@unused@*/ char *s = (char*)p;
}


/*@null@*/ int* q5() {
int * x = (int *) malloc(10);
free(x);
return x;

}

void q6(char/*@out@*/ *x,char *y) {
    strcpy(x,y);
}

void q7(int *x, int *y)
/*@modifies *x@*/
{
*y = *x;
}


void q8_1() {
    int x = 3;
    while(x!=0)
        printf("X");
}

void q8_2(int x) {

switch (x) {

    case 0: printf("0");
    case 1: printf("1");
    default:printf("default");
    }
}



void q9_1() {
    int x[5];
    x[10] = 3;
}

void q10() {
    int x = 3;
    int y = 4 * add(x++);
}




