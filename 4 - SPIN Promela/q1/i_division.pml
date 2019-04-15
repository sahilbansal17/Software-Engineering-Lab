// promela model for division

// tail recursive function for division
// division of x/y, resulting into quotient and remainder
proctype division(int x, y, q; chan res) {
	if 
	:: (y > x) -> res!q, x;
	:: (x >= y) -> run division(x - y, y, q + 1, res);
	fi
}

init {
	int q, r;
	// channel to store the result of division
	chan child = [1] of {int, int};
	run division(7, 2, 0, child);
	// extract values of q and r from the channel child
	child ? q,r;
	printf("quotient = %d\n", q);
	printf("remainder = %d\n", r);
}