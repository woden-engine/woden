commands
enterVRMode
	^ self ffiCall: #(void psvrd_client_enterVRMode(psvrd_client_connection_t self))