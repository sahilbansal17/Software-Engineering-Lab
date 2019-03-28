bool A_RUNS, B_RUNS, turn;
byte mutex; 

#define true 1 
#define false 0 
#define A_TURN 1 
#define B_TURN 0

proctype A() {
	A_RUNS = true;
	turn = B_TURN;
	B_RUNS == false || turn == A_TURN;
	mutex ++;
	printf("MSC: Process A has entered the critical section. \n");
	mutex --;
	A_RUNS = false;
}

proctype B() {
	B_RUNS = true;
	turn = A_TURN;
	A_RUNS == false || turn == B_TURN;
	mutex ++;
	printf("MSC: Process B has entered the critical section. \n");
	mutex --;
	B_RUNS = false;
}

proctype monitor() {
	assert (mutex != 2);
}

init {
	atomic { 
		run A();
		run B();
		run monitor();
	}
}