Class {
	#name : #WDBBabylonMeshMemoryMap,
	#superclass : #Object,
	#instVars : [
		'baseVertex',
		'baseIndex'
	],
	#category : #'WodenEngine-Babylon'
}

{ #category : #accessing }
WDBBabylonMeshMemoryMap >> baseIndex [
	^ baseIndex
]

{ #category : #accessing }
WDBBabylonMeshMemoryMap >> baseIndex: anObject [
	baseIndex := anObject
]

{ #category : #accessing }
WDBBabylonMeshMemoryMap >> baseVertex [
	^ baseVertex
]

{ #category : #accessing }
WDBBabylonMeshMemoryMap >> baseVertex: anObject [
	baseVertex := anObject
]
