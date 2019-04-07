// classical dining philosopher's problem
// no of philosophers = 5, i.e. fixed

// chopstick to the left of philosopher 'i' is 'i'
// chopstick to the right of philosopher 'i' is '(i + 1) % N', here N = 5
#define p 0
#define v 1
#define N 5 // no. of philosophers

chan sema = [0] of {bit};
int chopstick_done[N];

proctype dijkstra() {
	do
	::	sema ! p -> sema ? v;
	od
}

proctype philosopher(int id) {
	int left = id;
	int right = (id + 1) % N;
	do 
	::	sema ? p ->
		if 
		::  (!chopstick_done[left] && !chopstick_done[right]) ->
			chopstick_done[left] = 1;
			chopstick_done[right] = 1;
			sema ! v;
			printf("Philosopher %d ---- begins eating\n", id);

			sema ? p;
			chopstick_done[left] = 0;
			chopstick_done[right] = 0;
			sema ! v;
			printf("Philosopher %d ---- ends eating\n", id);
		::  (chopstick_done[left] || chopstick_done[right]) ->
			sema ! v;
		fi
	od	
}

init {
	int philosopher_done = 0;
	atomic {
		run dijkstra();
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