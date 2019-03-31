chan coin = [1] of {int}

mtype = {milk, plain}
chan chocolate = [1] of {bit, mtype}

int amount = 0;
int cust_money = 45;
int milk_count = 10, plain_count = 5;

proctype vender() {
	// models the vending machine
	int coin_value;
	do 
	:: 	(milk_count > 0 || plain_count > 0) ->
		coin ? coin_value;
		if
		:: 	(coin_value == 5)  -> 
			if 
			:: (milk_count == 0) -> chocolate ! 0, milk;
			:: (milk_count > 0)  ->	
				atomic {
					chocolate ! 1, milk; 
					milk_count --; 
					amount = amount + 5;
					cust_money = cust_money - 5;
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
					cust_money = cust_money - 10;
				}
			fi
		fi 
	:: 	(milk_count == 0 && plain_count == 0) -> 
		coin ? coin_value;
		if 
		:: 	(coin_value == 5)  -> chocolate ! 0, milk;
		::  (coin_value == 10) -> chocolate ! 0, plain;
		fi
	od
}

proctype customer() {
	bit status;
	do
	:: (cust_money >= 5) ->
		coin ! 5;
		chocolate ? status, milk;
		if 
		:: 	(status == 0) -> printf("Milk chocolate finished.\n");
		:: 	(status == 1) -> printf("Milk chocolate.\n");
		fi
	:: (cust_money >= 10) ->
		coin ! 10;
		chocolate ? status, plain;
		if
		:: 	(status == 0) -> printf("Plain chocolate finished.\n");
		:: 	(status == 1) -> printf("Plain chocolate.\n");
		fi
	:: (cust_money < 5) ->
		printf("Customey has no more money.\n");
		break;
	od
}

proctype monitor_vendor() {
	do
	:: assert(amount == (10 - milk_count)*5 + (5 - plain_count)*10);
	od
}

proctype monitor_customer() {
	do
	:: assert(cust_money + amount == 45);
	od
}

init {
	atomic {
		run customer();
		run vender();
		run monitor_vendor();
		run monitor_customer();
	}
}