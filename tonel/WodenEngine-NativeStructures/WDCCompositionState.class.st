Class {
	#name : #WDCCompositionState,
	#superclass : #SysmelStructureType,
	#instVars : [
		'#screenExtents => Float32x4'
	],
	#category : #'WodenEngine-NativeStructures-Core-Camera'
}

{ #category : #accessing }
WDCCompositionState >> screenExtents [
	^ screenExtents
]

{ #category : #accessing }
WDCCompositionState >> screenExtents: anObject [
	screenExtents := anObject
]
