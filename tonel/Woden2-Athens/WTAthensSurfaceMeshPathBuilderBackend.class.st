Class {
	#name : #WTAthensSurfaceMeshPathBuilderBackend,
	#superclass : #WTAthensMeshPathBuilderBackend,
	#instVars : [
		'surface',
		'pathVertexCount'
	],
	#category : 'Woden2-Athens'
}

{ #category : #adding }
WTAthensSurfaceMeshPathBuilderBackend >> addIndex: anIndex [
	surface addIndex: anIndex
]

{ #category : #accessing }
WTAthensSurfaceMeshPathBuilderBackend >> numberOfVertices [
	^ pathVertexCount
]

{ #category : #adding }
WTAthensSurfaceMeshPathBuilderBackend >> primitiveAddVertex: aPoint [
	surface addVertex: aPoint asWMVector2F.
	pathVertexCount := pathVertexCount + 1.
]

{ #category : #accessing }
WTAthensSurfaceMeshPathBuilderBackend >> reset [
	super reset.
	pathVertexCount := 0.
]

{ #category : #accessing }
WTAthensSurfaceMeshPathBuilderBackend >> surface [
	^ surface
]

{ #category : #accessing }
WTAthensSurfaceMeshPathBuilderBackend >> surface: anObject [
	surface := anObject
]
