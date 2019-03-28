byte count;

proctype counter1() {
	do 
	:: count != 0 ->
		if
		:: count ++;
		:: count --;
		fi
	:: else ->
		break;
	od
}

proctype counter2() {
	do 
	:: count ++;
	:: count --;
	:: (count == 10) ->
		break;
	od
}

init {
	run counter2();
}