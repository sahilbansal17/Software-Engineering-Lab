// a simple railway network
// three defective signals as processes
// two block sections of track by channels

#define TRAIN 1

chan block_section1 = [2] of {bit};
chan block_section2 = [2] of {bit};

// signal 1 is before the start of block section 1
proctype signal1() {
	// train enters the block section 1
	do
	::  atomic {
			block_section1 ! TRAIN;
			printf("Train has entered the block section 1.\n");
		}
	od
}

// signal 2 is after the end of block section 1 and 
// before the start of block section 2
proctype signal2() {
	// train exists the block section 1
	// and enters the block section 2
	do
	::  atomic {
			block_section1 ? TRAIN;
			printf("Train has exited the block section 1.\n");
			block_section2 ! TRAIN;
			printf("Train has entered the block section 2.\n");
		}
	od
}

// signal 3 is after the end of block section 2
proctype signal3() {
	// train exists from the block section 2
	do
	::  atomic {
			block_section2 ? TRAIN;
			printf("Train has exited the block section 2.\n");
		}
	od
}

proctype monitor() {
	do
	::  assert(len(block_section1) != 2 && len(block_section2) != 2);
	od
}

init {
	atomic {
		run signal1();
		run signal2();
		run signal3();
		run monitor();
	}
}