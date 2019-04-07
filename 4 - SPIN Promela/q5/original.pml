chan coin = [1] of {bit, int}

mtype = {milk, plain}
// bit used for parity to check whether message received is correct
chan chocolate = [1] of {bit, mtype}

proctype vender() {
	// models the vending machine
	int coin_value;
	bit parity;
	do 
	:: 	coin ? parity, coin_value ->
		// assert(parity == 1);
		if
		:: (parity == 1) ->
			if 
			:: (coin_value == 5)  -> chocolate ! 1, milk; 
			:: (coin_value == 10) -> chocolate ! 1, plain;
			fi 
		:: (parity != 1) ->
			if 
			:: (coin_value == 5) -> chocolate ! 0, milk;
			:: (coin_value == 10) -> chocolate ! 0, plain;
			fi
			printf("Vender received incorrect request\n");
		fi
	od
}

proctype customer() {
	// limitless appetite for chocolate, both plain and milk
	bit parity;
	do
	:: coin ! 1, 5 -> 
		chocolate ? parity, milk;
		// assert(parity == 1);
		if 
		:: (parity == 1) ->
			printf("Milk chocolate.\n");
		:: (parity != 1) ->
			printf("Incorrect response from the vender.\n");
		fi
	:: coin ! 1, 10 ->
		chocolate ? parity, plain;
		// assert(parity == 1);
		if
		:: (parity == 1) ->
			printf("Plain chocolate.\n");
		:: (parity != 1) ->
			printf("Incorrect response from the vender.\n");
		fi
	od
}

init {
	atomic {
		run customer();
		run vender();
	}
}