Class {
	#name : #WDCTerrainMeshVertexF32,
	#superclass : #WDCVertexDataStructure,
	#instVars : [
		'#position => CompactFloat32x3 location: 0'
	],
	#category : #'WodenEngine-NativeStructures-Core-Mesh'
}

{ #category : #accessing }
WDCTerrainMeshVertexF32 >> position [
	^ position
]

{ #category : #accessing }
WDCTerrainMeshVertexF32 >> position: anObject [
	position := anObject
]
