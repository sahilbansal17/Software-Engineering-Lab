// alternating bit protocol with no message loss
// two processes - sender and receiver
// sender sends message 0 and receiver receives it, sends ack 0
// on receiving ack 0 from receiver, sender sends message 1
// receiver receives it and sends ack 1
// this process is repeated indefinitely

// mtype defined as either msg or ack
mtype = {MSG, ACK};

// channel for message sent to sender
chan rec_to_send = [2] of {mtype, bit};

// channel for message sent to receiver
chan send_to_rec = [2] of {mtype, bit};

// sender process
proctype sender(chan in; chan out) {
	bit in_bit, out_bit;
	// repeatedly, send the message
	// receive the ack 
	do	
	::	out ! MSG(out_bit) ->
		in ? ACK(in_bit);
		if 
		::	in_bit == out_bit ->
			// if the received bit is same as sent bit
			// send alternate bit the next time
			out_bit = 1 - in_bit;
		::	else -> skip;
		fi
	od
}

// receiver process
proctype receiver(chan in; chan out) {
	bit in_bit, expected_bit;
	do 
	::	in ? MSG(in_bit) ->
		if 
		::	in_bit == expected_bit ->
			// if received bit same as the expected bit, the message is correct
			printf("Receiver received the message with bit: %d\n", in_bit);
			// update the bit expected in the next message
			expected_bit = 1 - expected_bit;
		::	else -> 
			printf("Receiver received unexpected message.\n");
			skip;
		fi
		out ! ACK(in_bit);
	::	timeout ->
		out ! ACK(in_bit);
	od
}

// main init process
init {
	run sender(rec_to_send, send_to_rec);
	run receiver(send_to_rec, rec_to_send);
}