// dekker's algorithm for mutual exclusion

bool A_RUNS, B_RUNS, turn;
byte mutex; 

#define true 1 
#define false 0 
#define A_TURN 1 
#define B_TURN 0

// process A
proctype A() {
	A_RUNS = true;
	turn = B_TURN;
	B_RUNS == false || turn == A_TURN;
	mutex ++;
	// critical section begins
	printf("MSC: Process A has entered the critical section. \n");
	mutex --;
	// critical section ends
	A_RUNS = false;
}

// process  B
proctype B() {
	B_RUNS = true;
	turn = A_TURN;
	A_RUNS == false || turn == B_TURN;
	mutex ++;
	// critical section begins
	printf("MSC: Process B has entered the critical section. \n");
	mutex --;
	// critical section ends
	B_RUNS = false;
}

// monitor process
proctype monitor() {
	// processes A and B should never be in the critical section at the same time
	assert (mutex != 2);
}

init {
	atomic { 
		run A();
		run B();
		run monitor();
	}
}