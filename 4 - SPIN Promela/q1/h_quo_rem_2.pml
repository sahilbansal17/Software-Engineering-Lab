byte in1, in2, a, b, quo, rem;
bit load = 0, done = 1;

proctype quo_rem() {
	do
	:: (load == 1) -> a = in1; b = in2; quo = 0; rem = a; done = 0;
	:: (load != 1) -> if 
					  :: (rem >= b) -> rem = rem - b; quo = quo + 1;
					  :: (b > rem)  -> done = 1;
					  fi
	od 
}

proctype env() {
	in1 = 7;
	in2 = 2;
	load = 1;
	done == 0; // wait till done is not equal to 0, indicates that value is loaded
	load = 0; // to proceed for the actual divison to take place
	done == 1; // wait for the division to complete
	printf("quotient = %d\n", quo);
	printf("remainder = %d\n", rem);
}
init {
	atomic {
		run quo_rem();
		run env();
	}
}

// In this program, even the output of quotient may be wrong
// This happens because, initially load = 0 and thus 
// the 2nd arm of the do statement keeps on executing 
// also rem = 0, b = 0 => rem >= b
// so quotient keeps on incrementing until the values are loaded after the load is set to 1 
// in the env proctype