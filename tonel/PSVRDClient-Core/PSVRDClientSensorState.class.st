Class {
	#name : #PSVRDClientSensorState,
	#superclass : #FFIExternalStructure,
	#classVars : [
		'OFFSET_ORIENTATION',
		'OFFSET_TRANSLATION'
	],
	#pools : [
		'PSVRDClientTypes'
	],
	#category : 'PSVRDClient-Core-PSVRDClient-Core'
}

{ #category : #'field definition' }
PSVRDClientSensorState class >> fieldsDesc [
	"
	self rebuildFieldAccessors
	"
	^ #(
		psvrd_quaternion_t orientation;
		psvrd_vector3_t translation;
	)
]

{ #category : #'accessing structure variables' }
PSVRDClientSensorState >> orientation [
	"This method was automatically generated"
	^ PSVRDQuaternion fromHandle: (handle referenceStructAt: OFFSET_ORIENTATION length: PSVRDQuaternion byteSize)
]

{ #category : #'accessing structure variables' }
PSVRDClientSensorState >> orientation: anObject [
	"This method was automatically generated"
	handle structAt: OFFSET_ORIENTATION put: anObject getHandle length: PSVRDQuaternion byteSize
]

{ #category : #'accessing structure variables' }
PSVRDClientSensorState >> translation [
	"This method was automatically generated"
	^ PSVRDVector3 fromHandle: (handle referenceStructAt: OFFSET_TRANSLATION length: PSVRDVector3 byteSize)
]

{ #category : #'accessing structure variables' }
PSVRDClientSensorState >> translation: anObject [
	"This method was automatically generated"
	handle structAt: OFFSET_TRANSLATION put: anObject getHandle length: PSVRDVector3 byteSize
]
