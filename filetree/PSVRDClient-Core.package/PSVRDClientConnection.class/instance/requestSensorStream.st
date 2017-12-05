commands
requestSensorStream
	^ self ffiCall: #(void psvrd_client_requestSensorStream(psvrd_client_connection_t self))