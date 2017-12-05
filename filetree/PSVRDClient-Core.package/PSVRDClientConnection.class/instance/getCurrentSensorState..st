commands
getCurrentSensorState: result
	^ self ffiCall: #(int psvrd_client_getCurrentSensorState(psvrd_client_connection_t self, psvrd_client_sensor_state_t *result))