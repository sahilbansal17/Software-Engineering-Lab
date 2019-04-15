// reader's writer's problem with multiple readers and one writer
// with protection against anomolous updates
// buffer size = 10

#define p 0
#define v 1
#define BUFFER_SIZE 10
#define NUM_READERS 10

chan sema = [0] of {bit}; // channel for dijkstra's semaphores
chan read_sema = [0] of {bit}; // semaphore for reader

int buffer[BUFFER_SIZE]; // buffer in common between reader and writer
int value = 0; // value produced by the reader
int filled = 0; // points to the next empty slot in the buffer
int reader_count = 0; // no. of readers reading at any moment
int read[NUM_READERS]; // stores the next index of the buffer to be read by a reader

// process for dijkstra's semaphores: reader-writer lock
proctype dijkstra() {
	do
	::	sema ! p -> sema ? v;
	od
}

// process for semaphores for multiple readers
proctype dijkstra_reader() {
	do
	::  read_sema ! p -> read_sema ? v;
	od
}

// writer process
proctype writer() {
	do 
	::	// acquire the reader-writer lock
		sema ? p ->
		if 
		:: 	// buffer is not full
			(filled < BUFFER_SIZE) ->
			// produce
			value ++;
			buffer[filled] = value;
			printf("WRITER is writing the value: %d\n", value);
			filled = (filled + 1);
			// release the reader-writer lock
			sema ! v;
		:: 	// buffer is full
			(filled == BUFFER_SIZE) ->
			printf("WRITER cannot write since the buffer is full.\n");
			// release the lock
		 	sema ! v;
		fi
	od	
}

// reader process
proctype reader(int i) {
	int val, index;
	do 
	::	// acquire the reader's lock
		read_sema ? p ->
		reader_count ++;
		if 
		::  // first reader, acquire the reader-writer lock
			(reader_count == 1) -> 
			sema ? p;
			printf("First READER has entered the critical section...\n");
		:: 	// not first, already RW-lock acquired earlier
			(reader_count > 1) -> skip;
		fi
		// release the reader's lock to allowed other readers to come in
		read_sema ! v;
		// printf("READER %d is reading.\n", i + 1);
		// find the index of buffer to be read by the current reader
		index = read[i];
		if 
		:: 	// current reader has read the complete buffer
			(index == BUFFER_SIZE) ->
			printf("READER %d has read the entire buffer.\n", i + 1);
		:: 	// current reader yet to read the buffer
			(index < BUFFER_SIZE) ->
			read[i] = read[i] + 1;
			val = buffer[index];
			printf("The value READ by the READER %d is: %d\n", i + 1, val);
		fi

		// acquire the reader's lock to decrease the reader's count
		read_sema ? p ->
		reader_count --;
		if 
		:: 	// last reader
			(reader_count == 0) ->
			printf("Last READER exiting the critical section...\n");
			// release the reader-writer's lock
			sema ! v;
		:: 	// not the last reader
			(reader_count > 0) -> skip;
		fi
		// release the reader's lock
		read_sema ! v;
	od
}	

init {
	int reader_done = 0;
	atomic {
		run dijkstra();
		run writer();
		// create multiple reader processes
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