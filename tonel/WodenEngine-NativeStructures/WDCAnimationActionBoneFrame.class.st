Class {
	#name : #WDCAnimationActionBoneFrame,
	#superclass : #SysmelStructureType,
	#instVars : [
		'#translation => Float32x3',
		'#rotation => QuaternionF32'
	],
	#category : #'WodenEngine-NativeStructures-Core-Mesh'
}

{ #category : #'as yet unclassified' }
WDCAnimationActionBoneFrame >> forwardMatrix [
	^ Float32x4x4 mat3: rotation asMatrix3x3 translation: translation
]

{ #category : #'as yet unclassified' }
WDCAnimationActionBoneFrame >> inverseMatrix [
	| inverseOrientation |
	inverseOrientation := rotation asMatrix3x3 transposed.
	^ Float32x4x4 mat3: inverseOrientation translation: (inverseOrientation * translation negated)
]

{ #category : #accessing }
WDCAnimationActionBoneFrame >> rotation [
	^ rotation
]

{ #category : #accessing }
WDCAnimationActionBoneFrame >> rotation: anObject [
	rotation := anObject
]

{ #category : #accessing }
WDCAnimationActionBoneFrame >> translation [
	^ translation
]

{ #category : #accessing }
WDCAnimationActionBoneFrame >> translation: anObject [
	translation := anObject
]
