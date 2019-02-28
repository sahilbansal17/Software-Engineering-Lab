proctype Hello() {
	printf("Hello world, PID of hello process is : %d\n", _pid)
}

init {
	int lastPID;
	printf("Hello world, PID of init process is : %d\n", _pid)
	//	lastPID = run Hello();
	//	printf("PID of the hello process viewed in init is : %d\n", lastPID)
}