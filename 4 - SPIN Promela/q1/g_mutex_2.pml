// mutual exclusion algorithm 2

bit flag1, flag2;
byte mutex;

// process A
proctype A() {
	flag1 = 1;
	flag2 == 0;
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
	flag1 == 0;
	mutex ++;
	// critical section begins
	printf("MSC: Process B has entered the critical section. \n");
	mutex --;
	// critical section ends
	flag2 = 0;
}

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