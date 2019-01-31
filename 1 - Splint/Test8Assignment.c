#include<stdio.h>
#include<stdlib.h>
//#include<q4.h>
#include<string.h>
#define add(x) x + x

typedef /*@abstract@*/ char *StringData;

/*@checkedstrict@*/int ct = 5;
int *gp;

void main() {

    printf("Hello");

}

void q1(/*@null@*/char * s) {
    strcpy(s,"shivanshu");

}

void q2() {
     int q;
     printf("Value of q is : %d", q);
}

void q3() {
  enum val{A,B,C};
  enum val p = 5;
}

void q4(StringData p) {
    char *s;
    strcpy(p,s);
}

void q5() {

char * str = (char *) malloc(15);

}

void q6(int/*@out@*/ *x)/*@modifies gp@*/ {
gp = x;

}


void q7_2() {
 ct = 3;
}


void q8_3() {
int x =3,y=3;
x == y;
}

int q8_4_1() {
 return 3;
}

void q8_4_2() {
 q8_4_1();
}


void q9_2(char* s) {
     char *tmp = (char *)malloc(10);
     strcpy(tmp,s);

}

void q10_2() {

int ct = 3;
}




