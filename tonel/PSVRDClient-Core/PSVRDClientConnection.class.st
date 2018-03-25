Class {
	#name : #PSVRDClientConnection,
	#superclass : #FFIExternalObject,
	#pools : [
		'PSVRDClientTypes'
	],
	#category : 'PSVRDClient-Core-PSVRDClient-Core'
}

{ #category : #'library path' }
PSVRDClientConnection class >> ffiLibraryName [
	^ 'libpsvrd-client.so'
]

{ #category : #'instance creation' }
PSVRDClientConnection class >> open [
	^ self ffiCall: #(psvrd_client_connection_t psvrd_client_openConnection ())
]

{ #category : #commands }
PSVRDClientConnection >> calibrateSensors [
	^ self ffiCall: #(void psvrd_client_calibrateSensors(psvrd_client_connection_t self))
]

{ #category : #'initialize-release' }
PSVRDClientConnection >> close [
	^ self ffiCall: #(void psvrd_client_closeConnection(psvrd_client_connection_t self))
]

{ #category : #commands }
PSVRDClientConnection >> enterCinematicMode [
	^ self ffiCall: #(void psvrd_client_enterCinematicMode(psvrd_client_connection_t self))
]

{ #category : #commands }
PSVRDClientConnection >> enterVRMode [
	^ self ffiCall: #(void psvrd_client_enterVRMode(psvrd_client_connection_t self))
]

{ #category : #'library path' }
PSVRDClientConnection >> ffiLibraryName [
	^ self class ffiLibraryName
]

{ #category : #commands }
PSVRDClientConnection >> getCurrentSensorState: result [
	^ self ffiCall: #(int psvrd_client_getCurrentSensorState(psvrd_client_connection_t self, psvrd_client_sensor_state_t *result))
]

{ #category : #commands }
PSVRDClientConnection >> headsetOff [
	^ self ffiCall: #(void psvrd_client_headsetOff(psvrd_client_connection_t self))
]

{ #category : #commands }
PSVRDClientConnection >> headsetOn [
	^ self ffiCall: #(void psvrd_client_headsetOn(psvrd_client_connection_t self))
]

{ #category : #commands }
PSVRDClientConnection >> headsetPower: aBoolean [
	^ self ffiCall: #(void psvrd_client_headsetOff(psvrd_client_connection_t self, bool aBoolean))
]

{ #category : #commands }
PSVRDClientConnection >> powerOff [
	^ self ffiCall: #(void psvrd_client_powerOff(psvrd_client_connection_t self, bool aBoolean))
]

{ #category : #commands }
PSVRDClientConnection >> recenter [
	^ self ffiCall: #(void psvrd_client_recenter(psvrd_client_connection_t self))
]

{ #category : #commands }
PSVRDClientConnection >> requestSensorStream [
	^ self ffiCall: #(void psvrd_client_requestSensorStream(psvrd_client_connection_t self))
]
