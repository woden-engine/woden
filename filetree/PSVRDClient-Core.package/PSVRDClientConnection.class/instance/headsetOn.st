commands
headsetOn
	^ self ffiCall: #(void psvrd_client_headsetOn(psvrd_client_connection_t self))