// promela model for factorial

// process to calculate factorial of n
// result stored in the channel p
proctype fact(int n; chan p) {
	int result;
	chan child = [1] of {int};
	if 
	:: (n <= 1) -> p!1;
	:: (n >= 2) ->
		run fact(n - 1, child);
		// get fact(n - 1) from child
		child ? result;
		// send n*fact(n - 1) to channel p
		p ! n*result;
	fi
}

init {
	int result;
	// to store the result of the factorial
	chan child = [1] of {int};
	// run the fact() process
	run fact(4, child);
	// retrieve the result
	child ? result;
	printf("%d! = %d\n", 4, result);
}