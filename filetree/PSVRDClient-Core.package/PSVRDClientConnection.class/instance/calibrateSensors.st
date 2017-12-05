commands
calibrateSensors
	^ self ffiCall: #(void psvrd_client_calibrateSensors(psvrd_client_connection_t self))