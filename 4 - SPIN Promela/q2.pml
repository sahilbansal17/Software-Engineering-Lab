// reader's writer's problem with multiple readers and one writer
// with protection against anomolous updates
// buffer size = 10

#define p 0
#define v 1
#define BUFFER_SIZE 10
#define NUM_READERS 10

chan sema = [0] of {bit};
chan read_sema = [0] of {bit}; // semaphore for reader

int buffer[BUFFER_SIZE];
int value = 0;
int filled = 0; // points to the next empty slot in the buffer
int reader_count = 0; // no. of readers reading at any moment
int read[NUM_READERS]; // stores the next index of the buffer to be read by a reader

proctype dijkstra() {
	do
	::	sema ! p -> sema ? v;
	od
}

proctype dijkstra_reader() {
	do
	::  read_sema ! p -> read_sema ? v;
	od
}

proctype writer() {
	do 
	::	sema ? p ->
		if 
		:: (filled < BUFFER_SIZE) ->
			// produce
			value ++;
			buffer[filled] = value;
			printf("WRITER is writing the value: %d\n", value);
			filled = (filled + 1);
			sema ! v;
		:: (filled == BUFFER_SIZE) ->
			printf("WRITER cannot write since the buffer is full.\n");
		 	sema ! v;
		fi
	od	
}

proctype reader(int i) {
	int val, index;
	do 
	::	read_sema ? p ->
		reader_count ++;
		if 
		:: (reader_count == 1) -> 
			sema ? p;
			printf("First READER has entered the critical section...\n");
		:: (reader_count > 1) -> skip;
		fi
		read_sema ! v;
		// printf("READER %d is reading.\n", i + 1);
		// find the index of buffer to be read by the current reader
		index = read[i];
		if 
		:: (index == BUFFER_SIZE) ->
			printf("READER %d has read the entire buffer.\n", i + 1);
		:: (index < BUFFER_SIZE) ->
			read[i] = read[i] + 1;
			val = buffer[index];
			printf("The value READ by the READER %d is: %d\n", i + 1, val);
		fi

		read_sema ? p ->
		reader_count --;
		if 
		:: (reader_count == 0) ->
			printf("Last READER exiting the critical section...\n");
			sema ! v;
		:: (reader_count > 0) -> skip;
		fi
		read_sema ! v;
	od
}	

init {
	int reader_done = 0;
	atomic {
		run dijkstra();
		run writer();
		do
		::  if 
			:: (reader_done == NUM_READERS) -> break;
			:: (reader_done < NUM_READERS) ->
				run reader(reader_done);
				reader_done ++;
			fi 
		od
		run dijkstra_reader();
	}
}