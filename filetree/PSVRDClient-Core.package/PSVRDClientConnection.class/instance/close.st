initialize-release
close
	^ self ffiCall: #(void psvrd_client_closeConnection(psvrd_client_connection_t self))