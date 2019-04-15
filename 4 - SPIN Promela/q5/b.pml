// adding a local assertion to the part a
// to express the fact that there is an invariant relationship
// between the amount of chocolates and the money hold by the vendor

chan coin = [1] of {int}

mtype = {milk, plain}
chan chocolate = [1] of {bit, mtype}

// coin box
int amount = 0;
// max chocolates available - vendor
int milk_count = 10, plain_count = 5;

// vender process
proctype vender() {
	// models the vending machine
	int coin_value;
	do 
	:: 	(milk_count > 0 || plain_count > 0) ->
		coin ? coin_value;
		// send chocolate as per the coin received
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
	:: 	// chocolates finished
		(milk_count == 0 && plain_count == 0) -> 
		coin ? coin_value;
		if 
		:: 	(coin_value == 5)  -> chocolate ! 0, milk;
		::  (coin_value == 10) -> chocolate ! 0, plain;
		fi
	od
}

// customer process
proctype customer() {
	bit status;
	// keep sending coins and receiving either chocolates or finished response
	do
	:: coin ! 5 -> 
		chocolate ? status, milk;
		if 
		:: 	(status == 0) -> printf("Milk chocolate finished.\n");
		:: 	(status == 1) -> printf("Milk chocolate.\n");
		fi
	:: coin ! 10 ->
		chocolate ? status, plain;
		if
		:: 	(status == 0) -> printf("Plain chocolate finished.\n");
		:: 	(status == 1) -> printf("Plain chocolate.\n");
		fi
	od
}

// the assetion to check the invariant between amount and the quantity left
proctype monitor() {
	do
	:: assert(amount == (10 - milk_count)*5 + (5 - plain_count)*10);
	od
}

init {
	atomic {
		run customer();
		run vender();
		run monitor();
	}
}