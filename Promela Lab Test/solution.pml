// Submitted by: SAHIL (2016UCS0008)

#define TRUE 1
#define FALSE 0

#define P 0
#define V 1

#define DONATION 1001
#define NUM_CUSTOMERS 3

int balance = 0;

// result channel is used to send the output of test_and_set to the process
chan result = [0] of {bit};
// sema channel used for dijsktra semaphores
chan sema = [0] of {bit};

// lock variable to synchronize various processes
bit lock;

// dijsktra semaphore
proctype dijsktra() {
	do 
	::  sema ! P -> sema ? V;
	od
}

// the test and set process
// sends the old value of lock to the calling process 
// and sets the lock to be true
proctype test_and_set() {
	// need to ensure that lock updation is atomic using semaphores
	// so both the statments in this process must completely execute before context switch
	sema ? P;
	result ! lock; // send the old value of lock to the result channel
	lock = TRUE; // update lock to TRUE
	sema ! V;
}

proctype customer(int id) {
	
	// acquire the lock using test_and_set
	do 
	::
		run test_and_set();
		// if we get the result to be false, this means old value of lock is false 
		// i.e. the lock has not been acquired by any process 
		// so the current process gets into the critical section 
		// also lock is set to be true
		// so no other process will get the result to be FALSE until lock is set to false again

		if 
		::	result ? TRUE -> skip;
		:: 	result ? FALSE -> break;
		fi
		
	od 

	printf("Customer %d has entered the critical section.\n", id);
	// critical section
	int temp = balance;
	temp = temp + DONATION;
	balance = temp;

	printf("Customer %d has exited the critical section.\n", id);

	// release the lock, i.e. update to FALSE
	// use semaphore to guarantee that lock is updated mutually exclusively
	sema ? P;
	lock = false;
	sema ! V;
}

init {
	lock = FALSE;
	int customer_done = 0;
	run dijsktra();
	// create customer processes equal to the NUM_CUSTOMERS
	do
	::  (customer_done < NUM_CUSTOMERS) ->
		run customer(customer_done);
		customer_done ++;
	::  (customer_done == NUM_CUSTOMERS) -> break;
	od
}