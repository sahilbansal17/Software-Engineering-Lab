// extend hello world with proctype control_2 
// so that hello is printed before the world
// using two channels

#define zero 0
#define one 1

chan hello_done = [1] of {bit};
chan world_done = [1] of {bit};

// process to print hello
proctype hello() {
	printf("Hello ");
}

// process to print world
proctype world() {
	printf("World\n");
}


// process to achieve the functionality using two channels
proctype control_2() {
	// send 0 to channel hello_done
	hello_done ! 0;
	bit val;
	do 
	::	// receive value from the hello_done channel
		hello_done ? val -> 
			if 
			:: 	// if val is 0, then run hello() and send 1 to hello_done
				(val == 0) -> run hello(); hello_done ! 1;
			:: 	// if val is 1, then run world() and send 1 to world_done
				(val == 1) -> run world(); world_done ! 1;
			fi
	::	// receive value from the world_done channel
		world_done ? val -> 
			if
			:: 	// if value received is 1, then break
				(val == 1) -> break;
			fi
	od 
}


// process to achieve functionality using 1 channel
proctype control_1() {
	chan a = [1] of {byte};
	byte done;
	// send 0 to channel a
	a!0;
	do
	:: a?done ->
		if 
		:: 	// if received 0, run hello and send 1
			(done == 0) -> atomic { run hello(); a!1; }
		:: 	// if received 1, run world and send 2
			(done == 1) -> atomic { run world(); a!2; } 
		:: 	// if received 2, terminate the do using break
			(done == 2) -> break;
		fi
	od
}

init {
	// run the control process
	run control_2();
}
