proctype division(int x, y, q; chan res) {
	if 
	:: (y > x) -> res!q, x;
	:: (x >= y) -> run division(x - y, y, q + 1, res);
	fi
}

init {
	int q, r;
	chan child = [1] of {int, int};
	run division(7, 2, 0, child);
	child ? q,r;
	printf("quotient = %d\n", q);
	printf("remainder = %d\n", r);
}