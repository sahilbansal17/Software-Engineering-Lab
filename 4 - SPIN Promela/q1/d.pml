byte state = 1;
proctype A() { atomic { (state == 1) -> state = state + 1} }
proctype B() { atomic { (state == 1) -> state = state - 1} }

init {
	run A();
	run B()
}

/*

Seed = 1 => state = 2
seed = 3 => state = 2
seed = 4 => state = 0
seed = 6 => state = 2
seed = 10 => state = 0

The output can never be equal to 1 now since all statements inside atomic in proctype must be executed without interrupt.
*/