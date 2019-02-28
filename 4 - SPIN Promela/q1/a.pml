byte x = 2, y = 3;
proctype A() { x = x + 1}
proctype B() { x = x - 1; y = y + x}
init {
	atomic{ run A(); run B()}
}
/*
The various windows displayed in the SPIN run are: 
- Automata View
- Data window
- Message Sequence Chart
- Process Sequence
- Queue

Running the program with different seeds provides different outputs in the data window.
Seed = 1234567 gives an output of x = 2, y = 4
Seed = 123456 gives an output of x = 2, y = 5


*/