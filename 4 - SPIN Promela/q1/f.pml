chan a = [1] of {byte}

proctype hello() {
	printf("Hello ")
}

proctype world() {
	printf("World\n")
}


proctype control() {
	byte done;
	a!0
	do
	:: a?done ->
		if 
		:: (done == 0) -> atomic { run hello(); a!1 }
		:: (done == 1) -> atomic { run world(); a!2 } 
		fi
	od
}

init {
	run control()
}