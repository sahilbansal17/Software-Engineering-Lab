// mutual exclusion algorithm 1

bit flag;
byte mutex;
proctype P(int i) {
	flag != 1;
	flag = 1;
	mutex ++;
	// critical section begins
	printf("MSC: P(%d) has entered the critical section\n", i);
	mutex --;
	// critical section ends
	flag = 0;
}

// monitor process
proctype monitor() {
	// processes P(0) and P(1) should never be inside the critical section at a time
	assert (mutex != 2);
}

init {
	atomic { 
		run P(0);
		run P(1);
		run monitor();
	}
}