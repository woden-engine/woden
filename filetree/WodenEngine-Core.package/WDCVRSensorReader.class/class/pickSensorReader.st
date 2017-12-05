as yet unclassified
pickSensorReader
	self allSubclassesDo: [ :sc |
		(sc isValid) ifTrue: [ ^ sc new ]
	].

	^ WDCVRNullSensorReader new