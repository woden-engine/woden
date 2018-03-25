Class {
	#name : #PSVRDVector3,
	#superclass : #FFIExternalStructure,
	#classVars : [
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
PSVRDVector3 class >> fieldsDesc [
	"
	self rebuildFieldAccessors
	"
	^ #(
		double x;
		double y;
		double z;
	)
]

{ #category : #'accessing structure variables' }
PSVRDVector3 >> x [
	"This method was automatically generated"
	^handle doubleAt: OFFSET_X
]

{ #category : #'accessing structure variables' }
PSVRDVector3 >> x: anObject [
	"This method was automatically generated"
	handle doubleAt: OFFSET_X put: anObject
]

{ #category : #'accessing structure variables' }
PSVRDVector3 >> y [
	"This method was automatically generated"
	^handle doubleAt: OFFSET_Y
]

{ #category : #'accessing structure variables' }
PSVRDVector3 >> y: anObject [
	"This method was automatically generated"
	handle doubleAt: OFFSET_Y put: anObject
]

{ #category : #'accessing structure variables' }
PSVRDVector3 >> z [
	"This method was automatically generated"
	^handle doubleAt: OFFSET_Z
]

{ #category : #'accessing structure variables' }
PSVRDVector3 >> z: anObject [
	"This method was automatically generated"
	handle doubleAt: OFFSET_Z put: anObject
]
