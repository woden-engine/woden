Class {
	#name : #WDCGenericVertexF32,
	#superclass : #WDCVertexDataStructure,
	#instVars : [
		'#position => CompactFloat32x3 location: 0',
		'#normal => CompactFloat32x3 location: 3',
		'#texcoord => Float32x2 location: 1',
		'#tangent4 => Float32x4 location: 4',
		'#color => Float32x4 location: 2'
	],
	#category : #'WodenEngine-NativeStructures-Core-Mesh'
}

{ #category : #accessing }
WDCGenericVertexF32 >> color [
	^ color
]

{ #category : #accessing }
WDCGenericVertexF32 >> color: anObject [
	color := anObject
]

{ #category : #'as yet unclassified' }
WDCGenericVertexF32 >> exportModelWith: exporter [
	exporter vertexWith: [ :vertexExporter |
		vertexExporter
			position: position;
			color: color;
			texcoord: texcoord;
			normal: normal;
			tangent4: tangent4
	]
]

{ #category : #accessing }
WDCGenericVertexF32 >> normal [
	^ normal
]

{ #category : #accessing }
WDCGenericVertexF32 >> normal: anObject [
	normal := anObject
]

{ #category : #accessing }
WDCGenericVertexF32 >> position [
	^ position
]

{ #category : #accessing }
WDCGenericVertexF32 >> position: anObject [
	position := anObject
]

{ #category : #accessing }
WDCGenericVertexF32 >> tangent4 [
	^ tangent4
]

{ #category : #accessing }
WDCGenericVertexF32 >> tangent4: anObject [
	tangent4 := anObject
]

{ #category : #accessing }
WDCGenericVertexF32 >> texcoord [
	^ texcoord
]

{ #category : #accessing }
WDCGenericVertexF32 >> texcoord: anObject [
	texcoord := anObject
]
