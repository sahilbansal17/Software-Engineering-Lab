// classical dining philosopher's problem
// no of philosophers = 5, i.e. fixed

// chopstick to the left of philosopher 'i' is 'i'
// chopstick to the right of philosopher 'i' is '(i + 1) % N', here N = 5
#define p 0
#define v 1
#define N 5 // no. of philosophers

// channel for dijkstra's semaphores
chan sema = [0] of {bit};
// array to store whether a chopstick is acquired by some philosopher
int chopstick_done[N];

// process for dijkstra's semaphores
proctype dijkstra() {
	do
	::	sema ! p -> sema ? v;
	od
}

proctype philosopher(int id) {
	// store the left and right chopstick numbers
	int left = id;
	int right = (id + 1) % N;
	do 
	::	// acquire the locks
		sema ? p ->
		if 
		:: 	// if both the left and right chopsticks are available
			(!chopstick_done[left] && !chopstick_done[right]) ->
			// acquire both left and right chopsticks
			chopstick_done[left] = 1;
			chopstick_done[right] = 1;
			// release the lock
			sema ! v;
			printf("Philosopher %d ---- begins eating\n", id);

			// acquire the lock to stop eating and release the chopsticks
			sema ? p;
			chopstick_done[left] = 0;
			chopstick_done[right] = 0;
			// release the lock
			sema ! v;
			printf("Philosopher %d ---- ends eating\n", id);
		::  // not both the chopsticks are available
			(chopstick_done[left] || chopstick_done[right]) ->
			// release the lock
			sema ! v;
		fi
	od	
}

init {
	int philosopher_done = 0;
	atomic {
		run dijkstra();
		// create N philosopher processes
		do
		::  if 
			:: (philosopher_done == N) -> break;
			:: (philosopher_done < N) ->
				run philosopher(philosopher_done);
				philosopher_done ++;
			fi 
		od
	}
}