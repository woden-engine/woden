session management
requestSensorStream
	self checkSession.
	sensorStreamRequested ifFalse: [
		connection requestSensorStream.
		sensorStreamRequested := true.
	]