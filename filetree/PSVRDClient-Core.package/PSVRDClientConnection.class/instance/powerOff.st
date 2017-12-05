commands
powerOff
	^ self ffiCall: #(void psvrd_client_powerOff(psvrd_client_connection_t self, bool aBoolean))