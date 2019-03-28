// implement and run the PROMELA model for the Producer Consumer problem
// with bounded buffer and using semaphore P and V operation code
// assuming the buffer size = 10 elements

#define p 0
#define v 1
#define BUFFER_SIZE 10

chan sema = [0] of {bit};

int buffer[BUFFER_SIZE];
int value = 0;
int filled = 0; // points to the next empty slot in the buffer 
int used = 0; // points to the next unused slot in the buffer

int current_size = 0;
proctype dijkstra() {
	do
	::	sema ! p -> sema ? v;
	od
}

proctype producer() {
	do 
	::	sema ? p ->
		if 
		:: (current_size < BUFFER_SIZE) ->
			// produce
			value ++;
			buffer[filled] = value;
			printf("The value PRODUCED is: %d\n", value);
			filled = (filled + 1) % BUFFER_SIZE;
			current_size ++;
			sema ! v;
		:: (current_size == BUFFER_SIZE) -> sema ! v;
		fi
	od	
}

proctype consumer() {
	do 
	::	sema ? p ->
		if 
		:: (current_size > 0) ->
			// consume 
			int tmp = buffer[used];
			used = (used + 1) % BUFFER_SIZE;
			printf("The value CONSUMED is: %d\n", tmp);
			current_size --;
			sema ! v;
		:: (current_size == 0) -> sema ! v;
		fi
	od
}	

init {
	atomic {
		run dijkstra();
		run producer();
		run consumer();
	}
}