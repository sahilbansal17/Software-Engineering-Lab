byte state = 1;
proctype A() { (state == 1) -> state = state + 1}
proctype B() { (state == 1) -> state = state - 1}

init {
	atomic { run A(); run B()}
}

/*

Seed = 1 => state = 1
seed = 3 => state = 1
seed = 4 => state = 1
seed = 6 => state = 2
seed = 10 => state = 0

*/