#include<stdio.h>
#include<stdlib.h>
//#include<q4.h>
#include<string.h>
#define add(x) x + x

typedef /*@abstract@*/ char *StringData;

/*@checkedstrict@*/int ct = 5; // ERROR 17: variable exported but not used outside the file
int *gp; // ERROR 18: variable exported but not used outside the file

void main() { // ERROR 1: function main should return int

    printf("Hello");

}

void q1(/*@null@*/char * s) {
    strcpy(s,"shivanshu"); // ERROR 2: possbily null storage passed as non-null param

}

void q2() {
     int q;
     printf("Value of q is : %d", q); // ERROR 3: variable q used before definition
}

void q3() {
  enum val{A,B,C};
  enum val p = 5; // ERROR 4: variable p declared but not used
}

void q4(StringData p) {
    char *s;
    strcpy(p,s); // ERROR 5: variable s used before definition
}

void q5() {

char * str = (char *) malloc(15); // ERROR 7: variable str declared but not used

} /* ERROR 6: fresh storage str not released before return
    str is allocated memory but not released the memory before returning from
    the function
    */

void q6(int/*@out@*/ *x)/*@modifies gp@*/ {
gp = x;

} // ERROR 8: out storage x not defined before return
// ERROR 9: function return with global gp not completely defined

void q7_2() {
 ct = 3; // ERROR 10: undocumented use of global ct
}


void q8_3() {
int x =3,y=3;
x == y; /* ERROR 11: statement has no effect, x == y, this returns 
            a boolean value, true or false which is not stored
            anywhere
        */
}

int q8_4_1() { // ERROR 19: function exported but not used outside the file
 return 3;
}

void q8_4_2() {
 q8_4_1(); // ERROR 12: return value (type int) ignored
}


void q9_2(char* s) {
     char *tmp = (char *)malloc(10);
     strcpy(tmp,s); // ERROR 13: possibly null storage 'tmp' passed as non-null param

} // ERROR 14: fresh storage 'temp' not release before return

void q10_2() {

int ct = 3; /* ERROR 15: variable ct shadows outer declaration
                ct was globally declared to be 5 and now it 
                is being modified
            */
// ERROR 16: variable ct declared but not used
}




