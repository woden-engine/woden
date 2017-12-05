session management
sensorState
	| orientation translation |
	self requestSensorStream.
	connection getCurrentSensorState: clientSensorState.
	
	orientation := clientSensorState orientation.
	translation := clientSensorState translation.

	sensorState
		orientation: (WMQuaternionF r: orientation w i:  orientation x j: orientation y k: orientation z);
		translation: (WMVector3F x: translation x y: translation y z: translation z).
	^ sensorState