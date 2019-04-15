// promela model for finding quotient and reminder - version 1

int a, b, quo, rem;
bit done, load;

// process to find quotient and remainder
proctype quo_rem() {
	do
	:: (load == 1) -> quo = 0; rem = a; done = 0; // initialization
	:: (load != 1) -> if 
					  :: (rem >= b) -> rem = rem - b; quo = quo + 1; // add to quo, decrease rem
					  :: (b > rem)  -> done = 1; break; // done, can stop the division
					  fi
	od 
}

init {
	// initialization
	a = 7; 
	b = 2;
	done = 1;
	load = 1;
	run quo_rem();
	done == 0; // wait till done is not equal to 0, indicates that value is loaded
	load = 0; // to proceed for the actual divison to take place
	done == 1; // wait for the division to complete
	printf("Result 1, quotient = %d\n", quo);
	printf("Result 2, remainder = %d\n", rem);
}