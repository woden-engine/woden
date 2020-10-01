Class {
	#name : #WDCCompositionVertexF32,
	#superclass : #WDCVertexDataStructure,
	#instVars : [
		'#position => Float32x2 location: 0'
	],
	#category : #'WodenEngine-NativeStructures-Core-Mesh'
}

{ #category : #accessing }
WDCCompositionVertexF32 >> position [
	^ position
]

{ #category : #accessing }
WDCCompositionVertexF32 >> position: anObject [
	position := anObject
]
