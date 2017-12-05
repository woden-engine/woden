accessing
vrSensorReader
	self flag: 'TODO: Do this properly'.
	^ vrSensorReader ifNil: [ vrSensorReader := WDCVRSensorReader current activate; yourself. ]