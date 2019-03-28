chan coin = [1] of {int}

mtype = {milk, plain}
chan chocolate = [1] of {mtype}

proctype vender() {
	// models the vending machine
	int coin_value;
	do 
	:: 	coin ? coin_value ->
		if
		:: (coin_value == 5)  -> chocolate ! milk; 
		:: (coin_value == 10) -> chocolate ! plain;
		fi 
	od
}

proctype customer() {
	// limitless appetite for chocolate, both plain and milk
	do
	:: coin ! 5 -> 
		chocolate ? milk;
		printf("Milk chocolate.\n");
	:: coin ! 10 ->
		chocolate ? plain;
		printf("Plain chocolate.\n");
	od
}

init {
	atomic {
		run customer();
		run vender();
	}
}