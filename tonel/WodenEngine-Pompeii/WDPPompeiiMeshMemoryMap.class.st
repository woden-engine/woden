Class {
	#name : #WDPPompeiiMeshMemoryMap,
	#superclass : #Object,
	#instVars : [
		'baseVertex',
		'baseIndex'
	],
	#category : #'WodenEngine-Pompeii'
}

{ #category : #accessing }
WDPPompeiiMeshMemoryMap >> baseIndex [
	^ baseIndex
]

{ #category : #accessing }
WDPPompeiiMeshMemoryMap >> baseIndex: anObject [
	baseIndex := anObject
]

{ #category : #accessing }
WDPPompeiiMeshMemoryMap >> baseVertex [
	^ baseVertex
]

{ #category : #accessing }
WDPPompeiiMeshMemoryMap >> baseVertex: anObject [
	baseVertex := anObject
]
