session management
startConnection
	connection := PSVRDClientConnection open.
	connection ifNil: [ self error: 'Failed to open a connection into the PSVRD daemon.' ].
	
	session := Smalltalk session.
	sensorStreamRequested := false.