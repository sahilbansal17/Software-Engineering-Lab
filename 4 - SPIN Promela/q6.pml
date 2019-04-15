// simple water storage system
// involves users, sensors, inlet and outlet devices
// user decides randomly whether or not to request the water
// water level = 20 => close the outlet and open the inlet
// water level = 30 => close the inlet and open the outlet

#define CLOSED 0
#define OPEN 1
#define p 0
#define v 1

// current water level
int water_level = 20;
// channel for requests
chan request = [0] of {byte};

// synchronous channel to send inlet status
chan inlet_status = [0] of {bit};
// synchronous channel to send outlet status
chan outlet_status = [0] of {bit};

// sensor process
proctype sensor() {
	do 
	::	if 
		// water level = 20 => close the outlet and open the inlet
		::  water_level == 20 ->  
			// printf("Water level = 20, Closing Outlet!\n");
			outlet_status ! CLOSED;
			inlet_status ! OPEN;
		// water level = 30 => close the inlet and open the outlet
		::  water_level == 30 ->
			// printf("Water level = 30, Closing Inlet!\n");
			outlet_status ! OPEN;
			inlet_status ! CLOSED;
		// water level between 20 and 30, keep the inlet open
		::  water_level > 20 && water_level < 30 ->
			outlet_status ! CLOSED;
			inlet_status ! OPEN;
		fi
	od
}

// user process
proctype user() {
	int qty, status;
	do 
	// randomly request for 1 unit of water or do not request
	::  qty = 1 ;
		request ! qty -> request ? status;
		assert(status == 1);
	::  request ! 0 -> request ? status;
		assert(status == 1);
	od
}

// inlet process
proctype inlet() {
	do 
	::  if 
		// get the inlet status, if open, increase water level
		::  atomic {
				inlet_status ? OPEN;
				water_level ++;
				printf("Water level is incremented by 1 unit.\n");
			}
		// if closed, do nothing
		::  atomic {
				inlet_status ? CLOSED;
				printf("Inlet is closed.\n");
			}
		fi
	od
}

// outlet process
proctype outlet() {
	int qty;
	do
	::	if 
		// get the outlet status, if open, server the request of the user
		::  outlet_status ? OPEN ->
			if 
			::  request ? 0 -> 
				printf("User is not requesting for water at the moment.\n");
				request ! 1;
			::  request ? qty ->
				atomic {
					water_level = water_level - qty;
					printf("User's request for 1 unit water is served.\n");
				}
				request ! 1;
			fi
		// get the outlet status, if closed, do nothing
		::	outlet_status ? CLOSED ->
			printf("Outlet is closed.\n");
		fi
	od
}

// monitor process
proctype monitor() {
	do
	::	assert(water_level >= 20 && water_level <= 30);
	od
}

init {
	atomic {
		run sensor();
		run user();
		run inlet();
		run outlet();
		run monitor();
	}
}
