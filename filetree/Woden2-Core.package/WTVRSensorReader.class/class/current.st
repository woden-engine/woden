accessing
current
	(CurrentSensorReader isNil or: [ CurrentSensorReaderSession ~~ Smalltalk session ]) ifTrue: [
		CurrentSensorReader := self pickSensorReader.
		CurrentSensorReaderSession := Smalltalk session.
	].

	^ CurrentSensorReader