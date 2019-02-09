#include<stdio.h>
#include<stdlib.h>
//#include<q4.h>
#include<string.h>
#define add(x) x + x

typedef /*@abstract@*/ char *StringData;

/*@checkedstrict@*/int ct = 5;

void main() { // ERROR 1: function main returns void, should return int

    printf("Hello");

}

int* q1(/*@null@*/int* s) {
    return s; /* ERROR 2: implicitly temp storage s defined as implicitly only
               since we are returning a pointer, it may be released memory
               or new aliases may be created
              */

    // ERROR 3: possibly null storage returned as non-null
}
void q2_1(/*@in@*/int* s) {} // ERROR 4: parameter s is not used
// ERROR 18: function exported but not used outside Test7Assignment

void q2(/*@out@*/int *s) {
     q2_1(s); // ERROR 5: passed storage s not completely defined
}

void q3() {
  char c;
  int i = 44;
  c = i; // ERROR 6: assignment of int to char
}

void q4(StringData p) {
    char *s = (char*)p; // ERROR 7: variable s declared but not used
}

int* q5() {

int * x = (int *) malloc(10);
free(x);
return x; // ERROR 8: Possibly null storage x returned as non-null
          // ERROR 9: variable x used after being released

}

void q6(char/*@out@*/ *x,char *y) {
    strcpy(x,y); /* ERROR 10: Parameter 1(x) to function strcpy is declared
                      unique but may be aliased externally by parameter 2 (y) 

                */
}

void q7(int *x, int *y)
/*@modifies *x@*/
{
*y = *x; // ERROR 11: Undocumented modification of *y
}


void q8_1() {
    int x = 3;
    while(x!=0) // ERROR 12: suspected infinite loop
        printf("X");
}

void q8_2(int x) {

switch (x) {

    case 0: printf("0");
    case 1: printf("1"); // ERROR 13: fall through case, no preceding break
    default:printf("default"); // ERROR 14: fall through case, no preceding break
    }
}



void q9_1() {
    int x[5];
    x[10] = 3;
}

void q10() {
    int x = 3;
    int y = 4 * add(x++); /* ERROR 15, 16: expression has undefined behaviour
                            This is because of the ill-defined macro add
                            add(x) should be defined as (x) + (x)
                            otherwise currently it is 'x + x'
                            so add(x++) = x++ + x++
                            The value x will be changed by either left or 
                            the right operand  
                          */
    // ERROR 17: variable y declared but not used
}




