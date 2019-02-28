byte state = 1;
proctype A() { (state == 1) -> state = state + 1}
proctype B() { (state == 1) -> state = state - 1}

init {
	run A();
	run B()
}

/*

Seed = 1 => state = 2
seed = 3 => state = 1
seed = 4 => state = 0

*/