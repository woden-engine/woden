Class {
	#name : #WDCTerrainMeshVertexF32,
	#superclass : #WDCVertexDataStructure,
	#instVars : [
		'#position => CompactFloat32x3 location: 0'
	],
	#category : #'WodenEngine-NativeStructures-Core-Mesh'
}

{ #category : #'as yet unclassified' }
WDCTerrainMeshVertexF32 >> exportModelWith: exporter [
	exporter vertexWith: [ :vertexExporter |
		vertexExporter
			position: (Float32x3 x: position x y: 0.0 z: position y);
			texcoord: position xy
	]
]

{ #category : #accessing }
WDCTerrainMeshVertexF32 >> position [
	^ position
]

{ #category : #accessing }
WDCTerrainMeshVertexF32 >> position: anObject [
	position := anObject
]
