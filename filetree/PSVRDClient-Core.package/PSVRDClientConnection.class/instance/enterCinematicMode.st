commands
enterCinematicMode
	^ self ffiCall: #(void psvrd_client_enterCinematicMode(psvrd_client_connection_t self))