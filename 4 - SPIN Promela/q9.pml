// promela model to model fan controller

// status of the fan
mtype = {IDLE, POWER, FAN};

// chan to store interaction between IDLE and POWER 
chan idle_power = [2] of {mtype, bit};
// chan to store interaction between POWER and FAN
chan power_fan = [2] of {mtype, bit};
// chan to store interaction between FAN and IDLE
chan fan_idle = [2] of {mtype, bit};
// mtype status for the current status of the fan
mtype status;

// process to handle transitions from idle state
proctype idle() {
	bit in;
	do 
	::	
		if
		// status is IDLE, go to POWER state
		::	status == IDLE ->
			idle_power ! POWER(1);
			atomic {
				status = POWER;
				printf("Fan goes from IDLE to POWER ON state.\n");
				idle_power ? POWER(in);
			}
		:: 	else -> skip;
		fi
		
	od
}

// process to handle transitions from power state
proctype power() {
	bit in;
	do 
	::	
		if
		// status is POWER, go to FAN state
		::	status == POWER ->
			power_fan ! FAN(1);
			atomic {
				printf("Fan goes from POWER ON to RUNNING state.\n");
				status = FAN;
				power_fan ? FAN(in);
			}
		// or go to IDLE state
		::	status == POWER ->
			idle_power ! IDLE(1);
			atomic {
				printf("Fan goes from POWER ON to IDLE state.\n");
				status = IDLE;
				idle_power ? IDLE(in);
			}
		:: 	else -> skip;
		fi
		
	od
}

// process to handle transitions from fan state
proctype fan() {
	bit in;
	do
	::	
		if
		// status is FAN, go to IDLE state
		::	status == FAN ->
			fan_idle ! IDLE(1);
			atomic {
				printf("Fan goes from RUNNING to IDLE state.\n");
				status = IDLE;
				fan_idle ? IDLE(in);
			}
		// or go to POWER state
		::	status == FAN ->
			power_fan ! POWER(1);
			atomic {
				printf("Fan goes from RUNNING to POWER ON state.\n");
				status = POWER;
				power_fan ? POWER(in);
			}
		::	else -> skip;
		fi
		
	od
}

init {
	// initial status
	status = IDLE;
	
	run idle();
	run power();
	run fan();
}