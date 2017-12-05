commands
recenter
	^ self ffiCall: #(void psvrd_client_recenter(psvrd_client_connection_t self))