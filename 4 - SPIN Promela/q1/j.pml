// implement and run the PROMELA model for the Producer Consumer problem
// with bounded buffer and using semaphore P and V operation code
// assuming the buffer size = 10 elements

#define p 0
#define v 1
#define BUFFER_SIZE 10

// chan for dijkstra's semaphores
chan sema = [0] of {bit};

int buffer[BUFFER_SIZE];
int value = 0; // value produced by the consumer
int filled = 0; // points to the next empty slot in the buffer 
int used = 0; // points to the next unused slot in the buffer

int current_size = 0;

// process for dijkstra's semaphores
proctype dijkstra() {
	do
	::	sema ! p -> sema ? v;
	od
}

// producer process
proctype producer() {
	do 
	::	// acquire the lock
		sema ? p ->
		if 
		:: 	// if buffer is not full, produce the value
			(current_size < BUFFER_SIZE) ->
			// produce
			value ++;
			buffer[filled] = value;
			printf("The value PRODUCED is: %d\n", value);
			// update the indices and size
			filled = (filled + 1) % BUFFER_SIZE;
			current_size ++;
			// release the lock
			sema ! v;
		:: 	// if buffer is full, release the lock
			(current_size == BUFFER_SIZE) -> sema ! v;
		fi
	od	
}

// consumer process
proctype consumer() {
	do 
	::	// acquire the lock
		sema ? p ->
		if 
		:: 	// if buffer is not empty, consume the item
			(current_size > 0) ->
			// consume 
			int tmp = buffer[used];
			used = (used + 1) % BUFFER_SIZE;
			printf("The value CONSUMED is: %d\n", tmp);
			// update the size
			current_size --;
			// release the lock
			sema ! v;
		:: 	// if buffer is empty, release the lock
			(current_size == 0) -> sema ! v;
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