// traffic signals at intersection of a highway and a farm road
// s1: signal for the highway
// s2: signal for the farm road

#define ON 1
#define OFF 0

mtype = { RED, ORANGE, GREEN };
byte s1_status; // signal for the highway
byte s2_status; // signal for the farm road
bit sensor_status; // sensor available on the farm road

/* for messages from HighwaySignal to FarmRoadSignal */
chan chan_s1 = [0] of {byte};

/* for messages from FarmRoadSignal to HighwaySignal */
chan chan_s2 = [0] of {byte};

/* for messages from sensor to FarmRoadSignal */
chan chan_sensor = [0] of {bit};

proctype HighwaySignal(mtype status) {
	s1_status = status;
	/* to model the case: if sensor is ON then S1 goes from ORANGE to RED after some time.
	Also send the status of the current signal to FarmRoadSignal process. 
	Also,
	if able to read from chan_s2, then go GREEN since s2_status goes to ORANGE and then RED */
	do
	:: 	if 
		// s2 requesting to go green
		::  chan_s2 ? GREEN;
			printf("Sensor is ON. S2 requesting to go GREEN.\n");
			// change s1 status to orange and then red
			s1_status = ORANGE;
			s1_status = RED;
			printf("S1 gone RED.\n");
			// send status of s1 to chan_s1
			chan_s1 ! RED;
			// wait till s2 goes green
			chan_s2 ? GREEN;
		// s2 requesting to go red
		::	chan_s2 ? RED;
			// change s1 to green
			s1_status = GREEN;
			printf("S1 gone GREEN.\n");
			// send s1 status to chan_s1
			chan_s1 ! GREEN;
		fi
	od
}

proctype FarmRoadSignal(mtype status) {
	/* to model the case that it has to get the message from HighwaySignal and then 
	go GREEN. 
	If one is able to read from chan_s1 then it implies that s1_status goes to GREEN
	and so S2 goes RED and sends status to HighwaySignal */
	s2_status = status;
	do
	::  if 
		// sensor goes on
		::  chan_sensor ? 1 ->
			// request to go green
			chan_s2 ! GREEN;
			// wait till s1 goes green
			chan_s1 ? RED;
			// go green
			s2_status = GREEN;
			printf("S2 gone GREEN.\n");
			// send its status to chan_s2
			chan_s2 ! GREEN;
		// sensore goes off
		::  chan_sensor ? 0 ->
			// goes orange then red
			s2_status = ORANGE;
			s2_status = RED;
			printf("Sensor is OFF. S2 gone RED.\n");
			// send status to chan_s2
			chan_s2 ! RED;
			chan_s1 ? GREEN;
		fi
	od
}

proctype Sensor() {
	// randomly make the sensor ON/OFF and send the status to the channel chan_sensor
	do
	::	if
		::	sensor_status = ON
		:: 	sensor_status = OFF
		fi
		chan_sensor ! sensor_status;
	od
}

init {
	atomic {
		run HighwaySignal(GREEN);
		run FarmRoadSignal(RED);
		run Sensor();
	}
}