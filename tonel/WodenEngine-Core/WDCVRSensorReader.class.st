Class {
	#name : #WDCVRSensorReader,
	#superclass : #Object,
	#classVars : [
		'CurrentSensorReader',
		'CurrentSensorReaderSession'
	],
	#category : 'WodenEngine-Core-VR'
}

{ #category : #accessing }
WDCVRSensorReader class >> current [
	(CurrentSensorReader isNil or: [ CurrentSensorReaderSession ~~ Smalltalk session ]) ifTrue: [
		CurrentSensorReader := self pickSensorReader.
		CurrentSensorReaderSession := Smalltalk session.
	].

	^ CurrentSensorReader
]

{ #category : #testing }
WDCVRSensorReader class >> isValid [
	^ false
]

{ #category : #'as yet unclassified' }
WDCVRSensorReader class >> pickSensorReader [
	self allSubclassesDo: [ :sc |
		(sc isValid) ifTrue: [ ^ sc new ]
	].

	^ WDCVRNullSensorReader new
]

{ #category : #commands }
WDCVRSensorReader >> activate [
]

{ #category : #commands }
WDCVRSensorReader >> calibrate [
]

{ #category : #commands }
WDCVRSensorReader >> recenter [
]

{ #category : #'session management' }
WDCVRSensorReader >> sensorState [
	self subclassResponsibility
]
