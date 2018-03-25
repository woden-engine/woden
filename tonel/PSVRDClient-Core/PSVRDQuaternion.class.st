Class {
	#name : #PSVRDQuaternion,
	#superclass : #FFIExternalStructure,
	#classVars : [
		'OFFSET_W',
		'OFFSET_X',
		'OFFSET_Y',
		'OFFSET_Z'
	],
	#pools : [
		'PSVRDClientTypes'
	],
	#category : 'PSVRDClient-Core-PSVRDClient-Core'
}

{ #category : #'field definition' }
PSVRDQuaternion class >> fieldsDesc [
	"
	self rebuildFieldAccessors
	"
	^ #(
		double x;
		double y;
		double z;
		double w;
	)
]

{ #category : #'accessing structure variables' }
PSVRDQuaternion >> w [
	"This method was automatically generated"
	^handle doubleAt: OFFSET_W
]

{ #category : #'accessing structure variables' }
PSVRDQuaternion >> w: anObject [
	"This method was automatically generated"
	handle doubleAt: OFFSET_W put: anObject
]

{ #category : #'accessing structure variables' }
PSVRDQuaternion >> x [
	"This method was automatically generated"
	^handle doubleAt: OFFSET_X
]

{ #category : #'accessing structure variables' }
PSVRDQuaternion >> x: anObject [
	"This method was automatically generated"
	handle doubleAt: OFFSET_X put: anObject
]

{ #category : #'accessing structure variables' }
PSVRDQuaternion >> y [
	"This method was automatically generated"
	^handle doubleAt: OFFSET_Y
]

{ #category : #'accessing structure variables' }
PSVRDQuaternion >> y: anObject [
	"This method was automatically generated"
	handle doubleAt: OFFSET_Y put: anObject
]

{ #category : #'accessing structure variables' }
PSVRDQuaternion >> z [
	"This method was automatically generated"
	^handle doubleAt: OFFSET_Z
]

{ #category : #'accessing structure variables' }
PSVRDQuaternion >> z: anObject [
	"This method was automatically generated"
	handle doubleAt: OFFSET_Z put: anObject
]
