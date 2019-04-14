// promela model to model fan controller

// status of the fan
mtype = {IDLE, POWER, FAN};

#define P 0
#define V 1

chan idle_power = [2] of {mtype, bit};
chan power_fan = [2] of {mtype, bit};
chan fan_idle = [2] of {mtype, bit};
chan sema = [0] of {bit};
mtype status;

proctype dijkstra() {
	do 
	::	sema ! P -> sema ? V;
	od
}

proctype idle() {
	bit in;
	do 
	::	sema ? P;
		if
		::	status == IDLE ->
			idle_power ! POWER(1);
			// idle_power ? ACK(in);
			// if 
			// ::	in == 1 ->
				atomic {
					status = POWER;
					printf("Fan goes from IDLE to POWER ON state.\n");
					idle_power ? POWER(in);
				}
			// ::	else -> skip;
			// fi
		/*
		::	status == POWER ->
			idle_power ? IDLE(in);
			if 
			::	in == 1 ->
				idle_power ! ACK(1);
			:: 	else -> skip;
			fi
		::	status == FAN ->
			fan_idle ? IDLE(in);
			if
			::	in == 1 ->
				fan_idle ! ACK(1);
			::	else -> skip;
			fi
		*/
		:: 	else -> skip;
		fi
		sema ! V;
	od
}

proctype power() {
	bit in;
	do 
	::	sema ? P;
		if
		::	status == POWER ->
			power_fan ! FAN(1);
			// power_fan ? ACK(in);
			// if
			// ::	in == 1 ->
				atomic {
					printf("Fan goes from POWER ON to RUNNING state.\n");
					status = FAN;
					power_fan ? FAN(in);
				}
			// ::	else -> skip;
			// fi
		::	status == POWER ->
			idle_power ! IDLE(1);
			// idle_power ? ACK(in);
			// if 
			// ::	in == 1 ->
				atomic {
					printf("Fan goes from POWER ON to IDLE state.\n");
					status = IDLE;
					idle_power ? IDLE(in);
				}
			// ::	else -> skip;
			// fi
		/*
		::	status == IDLE ->
			idle_power ? POWER(in);
			if 
			::	in == 1 ->
				idle_power ! ACK(1);
			::	else -> skip;
			fi
		::	status == FAN ->
			power_fan ? POWER(in);
			if
			::	in == 1 ->
				power_fan ! ACK(1);
			::
				else -> skip;
			fi
		*/
		:: 	else -> skip;
		fi
		sema ! V;
	od
}

proctype fan() {
	bit in;
	do
	::	sema ? P;
		if
		::	status == FAN ->
			fan_idle ! IDLE(1);
			// fan_idle ? ACK(in);
			// if
			// ::	in == 1 ->
				atomic {
					printf("Fan goes from RUNNING to IDLE state.\n");
					status = IDLE;
					fan_idle ? IDLE(in);
				}
			// ::	else -> skip;
			// fi
		::	status == FAN ->
			power_fan ! POWER(1);
			// power_fan ? ACK(in);
			// if 
			// ::	in == 1 ->
				atomic {
					printf("Fan goes from RUNNING to POWER ON state.\n");
					status = POWER;
					power_fan ? POWER(in);
				}
			// ::	else -> skip;
			// fi
		/*
		::	status == POWER ->
			power_fan ? FAN(in);
			if 
			::	in == 1 ->
				power_fan ! ACK(1);
			::	else -> skip;
			fi
		::	status == IDLE -> 
			skip;
		*/
		::	else -> skip;
		fi
		sema ! V;
	od
}

init {
	// initial status
	status = IDLE;
	run dijkstra();
	run idle();
	run power();
	run fan();
}