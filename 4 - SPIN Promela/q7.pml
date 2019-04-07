#define ON 1
#define OFF 0
mtype = { RED, ORANGE, GREEN };
byte s1_status; // signal for the highway
byte s2_status; // signal for the farm road
bit sensor_status; // sensor available on the farm road
chan chan_s1 = [0] of {byte};
/* for messages from HighwaySignal to FarmRoadSignal */
chan chan_s2 = [0] of {byte};
/* for messages from FarmRoadSignal to HighwaySignal */
chan chan_sensor = [0] of {bit};
/* for messages from sensor to FarmRoadSignal */

proctype HighwaySignal(mtype status) {
	bit sense = Off;
	int count;
	s1_status = status;
	byte temp;
	/* to model the case: if sensor is ON then S1 goes from ORANGE to RED after some time.
	Also send the status of the current signal to FarmRoadSignal process. 
	Also,
	if able to read from chan_s2, then go GREEN since s2_status goes to ORANGE and then RED */
	if 
	:: (sensor_status == ON) -> 
}

proctype FarmRoadSignal(mtype status) {
	/* to model the case that it has to get the message from HighwaySignal and then 
	go GREEN. 
	If one is able to read from chan_s1 then it implies that s1_status goes to GREEN
	and so S2 goes RED and sends status to HighwaySignal */
	
}

proctype Sensor() {
	do
	::	if
		:: sensor_status = On;
		:: sensor_status = Off;
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