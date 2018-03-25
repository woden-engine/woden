Class {
	#name : #PSVRDClientTypes,
	#superclass : #SharedPool,
	#classVars : [
		'psvrd_client_connection_t',
		'psvrd_client_error_t',
		'psvrd_client_sensor_state_t',
		'psvrd_quaternion_t',
		'psvrd_vector3_t'
	],
	#category : 'PSVRDClient-Core-PSVRDClient-Core'
}

{ #category : #initialization }
PSVRDClientTypes class >> initialize [
	psvrd_client_connection_t := PSVRDClientConnection.
	psvrd_client_error_t := #uint.
	psvrd_vector3_t := PSVRDVector3.
	psvrd_quaternion_t  := PSVRDQuaternion.
	psvrd_client_sensor_state_t := PSVRDClientSensorState.
]
