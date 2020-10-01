Class {
	#name : #WDCGenericObjectState,
	#superclass : #SysmelStructureType,
	#instVars : [
		'#transform => ReversibleAffineTransform3dF32',
		'#color => Float32x4',
		'#visible => Int32'
	],
	#category : #'WodenEngine-NativeStructures-Core-Material'
}

{ #category : #construction }
WDCGenericObjectState class >> neutralState [
	^ self new
		transform: ReversibleAffineTransform3dF32 identity;
		color: (Float32x4 x: 1.0 y: 1.0 z: 1.0 w: 1.0);
		visible: 1;
		yourself
]

{ #category : #accessing }
WDCGenericObjectState >> color [
	^ color
]

{ #category : #accessing }
WDCGenericObjectState >> color: anObject [
	color := anObject
]

{ #category : #accessing }
WDCGenericObjectState >> transform [
	^ transform
]

{ #category : #accessing }
WDCGenericObjectState >> transform: anObject [
	transform := anObject
]

{ #category : #accessing }
WDCGenericObjectState >> visible [
	^ visible
]

{ #category : #accessing }
WDCGenericObjectState >> visible: anObject [
	visible := anObject
]
