// original case when vender has infinite supply
// and custome has limitless appetite for chocolates, both plain and milk

// coin channel to exchange coin from customer
chan coin = [1] of {bit, int}

// type of chocolates
mtype = {milk, plain}

// chocolate channel to exchange chocolate from vendor
// bit used for parity to check whether message received is correct
chan chocolate = [1] of {bit, mtype}

// vender process
proctype vender() {
	// models the vending machine
	int coin_value;
	bit parity;
	do 
	:: 	coin ? parity, coin_value ->
		// assert(parity == 1);
		if
		:: (parity == 1) ->
			// send the chocolate as per the request, status sent is 1
			if 
			:: (coin_value == 5)  -> chocolate ! 1, milk; 
			:: (coin_value == 10) -> chocolate ! 1, plain;
			fi 
		:: (parity != 1) ->
			// don't send chocolate, status sent is 0
			if 
			:: (coin_value == 5) -> chocolate ! 0, milk;
			:: (coin_value == 10) -> chocolate ! 0, plain;
			fi
			printf("Vender received incorrect request\n");
		fi
	od
}

// customer process
proctype customer() {
	// limitless appetite for chocolate, both plain and milk
	bit parity;
	// send the coins
	// receive the chocolates as per the coin sent
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