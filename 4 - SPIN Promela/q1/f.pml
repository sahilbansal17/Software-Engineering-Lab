chan hello_done = [1] of {bit}
chan world_done = [1] of {bit}

#define zero 0
#define one 1

proctype hello() {
	printf("Hello ")
}

proctype world() {
	printf("World\n")
}

// using 1 channel
proctype control_1() {
	chan a = [1] of {byte};
	byte done;
	a!0;
	do
	:: a?done ->
		if 
		:: (done == 0) -> atomic { run hello(); a!1; }
		:: (done == 1) -> atomic { run world(); a!2; } 
		:: (done == 2) -> break;
		fi
	od
}

// using two channels
proctype control_2() {
	hello_done ! 0;
	bit val;
	do 
	::	hello_done ? val -> 
			if 
			:: (val == 0) -> run hello(); hello_done ! 1;
			:: (val == 1) -> run world(); world_done ! 1;
			fi
	::	world_done ? val -> 
			if
			:: (val == 1) -> break;
			fi
	od 
}

init {
	run control_2();
}
