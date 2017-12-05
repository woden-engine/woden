commands
headsetPower: aBoolean
	^ self ffiCall: #(void psvrd_client_headsetOff(psvrd_client_connection_t self, bool aBoolean))