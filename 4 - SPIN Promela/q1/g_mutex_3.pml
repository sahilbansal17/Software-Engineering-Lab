// mutual exclusion algorithm 3

bit flag1, flag2;
byte mutex, turn;

#define A_TURN 1
#define B_TURN 2

// process A
proctype A() {
	flag1 = 1;
	turn = B_TURN;
	flag2 == 0 || turn == A_TURN;
	mutex ++;
	// critical section begins
	printf("MSC: Process A has entered the critical section. \n");
	mutex --;
	// critical section ends
	flag1 = 0;
}

// process B
proctype B() {
	flag2 = 1;
	turn = A_TURN;
	flag1 == 0 || turn == B_TURN;
	mutex ++;
	// critical section begins
	printf("MSC: Process B has entered the critical section. \n");
	mutex --;
	// critical section ends
	flag2 = 0;
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