// final refinement to the vending machine
// customer has only 45 Rs to spend
// also system invariant included to make sure
// total money in the system is always 45 Rs.
chan coin = [1] of {int}

mtype = {milk, plain}
chan chocolate = [1] of {bit, mtype}

int amount = 0;
// amount of money with the customer
int cust_money = 45;
// quantity of chocolate available with the vendor
int milk_count = 10, plain_count = 5;

#define p 0
#define v 1
// semaphore channel
chan sema = [0] of {bit};

// dijkstra's semahore process
proctype dijkstra() {
	do
	:: sema!p -> sema?v;
	od
}

// vender process
proctype vender() {
	// models the vending machine
	int coin_value;
	do 
	:: 	(milk_count > 0 || plain_count > 0) ->
		coin ? coin_value;
		// send the chocolate as per the coin received
		if
		:: 	(coin_value == 5)  -> 
			if 
			:: (milk_count == 0) -> chocolate ! 0, milk;
			:: (milk_count > 0)  ->	
				atomic {
					chocolate ! 1, milk; 
					milk_count --; 
					amount = amount + 5;
				}
			fi
		:: 	(coin_value == 10) -> 
			if 
			:: (plain_count == 0) -> chocolate ! 0, plain;
			:: (plain_count > 0)  ->
				atomic {
					chocolate ! 1, plain; 
					plain_count --;
					amount = amount + 10;
				}
			fi
		fi 
	:: 	(milk_count == 0 && plain_count == 0) -> 
		coin ? coin_value;
		// chocolates finished
		if 
		:: 	(coin_value == 5)  -> chocolate ! 0, milk;
		::  (coin_value == 10) -> chocolate ! 0, plain;
		fi
	od
}

proctype customer() {
	bit status; // whether chocolate received or finished
	do
	:: 	// if money >= 5, request for milk chocolate
		(cust_money >= 5) ->
		sema ? p;
		coin ! 5;
		cust_money = cust_money - 5;
		chocolate ? status, milk;
		if 
		:: 	(status == 0) -> printf("Milk chocolate finished.\n");
		:: 	(status == 1) -> printf("Milk chocolate.\n");
		fi
		sema ! v;
	:: 	// money >= 10, request for plain chocolate
		(cust_money >= 10) ->
		sema ? p;
		coin ! 10;
		cust_money = cust_money - 10;
		chocolate ? status, plain;
		if
		:: 	(status == 0) -> printf("Plain chocolate finished.\n");
		:: 	(status == 1) -> printf("Plain chocolate.\n");
		fi
		sema ! v;
	:: 	// money less than 5, cannot request for any chocolate
		(cust_money < 5) ->
		sema ? p;
		printf("Customey has no more money.\n");
		sema ! v;
		break;
	od
}

// monitor vender, amount and quantity
proctype monitor_vender() {
	do
	::	assert(amount == (10 - milk_count)*5 + (5 - plain_count)*10);
	od
}

// monitor system, total money in system == 45
proctype monitor_system() {
	do
	:: sema ? p; assert(cust_money + amount == 45); sema ! v;
	od
}

init {
	atomic {
		run customer();
		run vender();
		run monitor_vender();
		run monitor_system();
		run dijkstra();
	}
}