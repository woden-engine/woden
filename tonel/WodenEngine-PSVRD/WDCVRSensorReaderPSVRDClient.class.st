Class {
	#name : #WDCVRSensorReaderPSVRDClient,
	#superclass : #WDCVRSensorReader,
	#instVars : [
		'connection',
		'session',
		'sensorStreamRequested',
		'clientSensorState',
		'sensorState'
	],
	#category : 'WodenEngine-PSVRD'
}

{ #category : #testing }
WDCVRSensorReaderPSVRDClient class >> isValid [
	^ true
]

{ #category : #commands }
WDCVRSensorReaderPSVRDClient >> activate [
	self checkSession.
	connection headsetOn; enterVRMode.

]

{ #category : #commands }
WDCVRSensorReaderPSVRDClient >> calibrate [
	self checkSession.
	connection calibrateSensors.

]

{ #category : #'session management' }
WDCVRSensorReaderPSVRDClient >> checkSession [
	(connection isNil or: [session ~~ Smalltalk session]) ifTrue: [
		self startConnection
	]
]

{ #category : #initialization }
WDCVRSensorReaderPSVRDClient >> initialize [
	super initialize.
	clientSensorState := PSVRDClientSensorState new.
	sensorState := WDCVRSensorState new.
]

{ #category : #commands }
WDCVRSensorReaderPSVRDClient >> recenter [
	self checkSession.
	connection recenter.

]

{ #category : #'session management' }
WDCVRSensorReaderPSVRDClient >> requestSensorStream [
	self checkSession
]

{ #category : #'session management' }
WDCVRSensorReaderPSVRDClient >> sensorState [
	| orientation translation |
	self requestSensorStream.
	connection getCurrentSensorState: clientSensorState.
	
	orientation := clientSensorState orientation.
	translation := clientSensorState translation.

	sensorState
		orientation: (WMQuaternionF r: orientation w i:  orientation x j: orientation y k: orientation z);
		translation: (WMVector3F x: translation x y: translation y z: translation z).
	^ sensorState
]

{ #category : #'session management' }
WDCVRSensorReaderPSVRDClient >> startConnection [
	connection := PSVRDClientConnection open.
	connection ifNil: [ self error: 'Failed to open a connection into the PSVRD daemon.' ].
	
	session := Smalltalk session.
	sensorStreamRequested := false.
]
