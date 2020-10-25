Class {
	#name : #WDCSkinnedModelBoneState,
	#superclass : #Object,
	#instVars : [
		'scale',
		'rotation',
		'translation',
		'matrix'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Asset'
}

{ #category : #initialization }
WDCSkinnedModelBoneState >> initialize [
	super initialize.
	rotation := QuaternionF32 identity.
	scale := Float32x3 ones.
	translation := Float32x3 zeros.
	matrix := Float32x4x4 identity.
]

{ #category : #'as yet unclassified' }
WDCSkinnedModelBoneState >> loadStateFrom: other [
	self
		scale: other scale;
		rotation: other rotation;
		translation: other translation
]

{ #category : #accessing }
WDCSkinnedModelBoneState >> matrix [
	^ matrix ifNil: [matrix := Float32x4x4 mat3: (Float32x3x3 scale: scale) * rotation asMatrix3x3 translation: translation]
]

{ #category : #accessing }
WDCSkinnedModelBoneState >> rotation [
	^ rotation
]

{ #category : #accessing }
WDCSkinnedModelBoneState >> rotation: anObject [
	rotation := anObject.
	matrix := nil.
]

{ #category : #accessing }
WDCSkinnedModelBoneState >> scale [
	^ scale
]

{ #category : #accessing }
WDCSkinnedModelBoneState >> scale: anObject [
	scale := anObject.
	matrix := nil.
]

{ #category : #accessing }
WDCSkinnedModelBoneState >> transform [
	^ ReversibleAffineTransform3dF32 new
		orthonormal: rotation asMatrix3x3;
		scaleBy: scale;
		translation: translation;
		yourself
]

{ #category : #accessing }
WDCSkinnedModelBoneState >> translation [
	^ translation
]

{ #category : #accessing }
WDCSkinnedModelBoneState >> translation: anObject [
	translation := anObject.
	matrix := nil.
]
