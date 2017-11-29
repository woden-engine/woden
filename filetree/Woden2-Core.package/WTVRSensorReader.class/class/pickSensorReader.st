as yet unclassified
pickSensorReader
	self allSubclassesDo: [ :sc |
		(sc isValid) ifTrue: [ ^ sc new ]
	].

	^ WTVRNullSensorReader new