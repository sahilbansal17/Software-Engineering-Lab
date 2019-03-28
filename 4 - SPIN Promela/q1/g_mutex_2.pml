bit flag1, flag2;
byte mutex;

proctype A() {
	flag1 = 1;
	flag2 == 0;
	mutex ++;
	printf("MSC: Process A has entered the critical section. \n");
	mutex --;
	flag1 = 0;
}

proctype B() {
	flag2 = 1;
	flag1 == 0;
	mutex ++;
	printf("MSC: Process B has entered the critical section. \n");
	mutex --;
	flag2 = 0;
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