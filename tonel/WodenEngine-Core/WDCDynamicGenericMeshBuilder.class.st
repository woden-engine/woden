Class {
	#name : #WDCDynamicGenericMeshBuilder,
	#superclass : #WDCComplexGenericMeshBuilder,
	#instVars : [
		'vertexBuffer',
		'vertexBufferCapacity',
		'indexBuffer',
		'indexBufferCapacity',
		'vertexBinding',
		'instantiatedMesh'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #'as yet unclassified' }
WDCDynamicGenericMeshBuilder >> createIndexBuffer [
	| encodedData |
	(indexBuffer isNil or: [ indexBufferCapacity < indices size ]) ifTrue: [
		indexBufferCapacity := indices capacity.
		indexBuffer := engine createIndex: indices elementSize streamingElements: indexBufferCapacity.
	].

	encodedData := indices rawData.
	indexBuffer data: encodedData.
	engine isDummyEngine ifFalse: [ 
		LibC memCopy: encodedData to: indexBuffer validPointer size: indices rawDataSize.
	].
	^ indexBuffer
]

{ #category : #'as yet unclassified' }
WDCDynamicGenericMeshBuilder >> createMeshWithSubmeshes: newSubmeshes [
	(instantiatedMesh isNotNil and: [ newSubmeshes = instantiatedMesh submeshes ]) ifTrue: [
		self
			createVertexBuffer;
			createIndexBuffer.
		^ instantiatedMesh
	].

	^ super createMeshWithSubmeshes: newSubmeshes
]

{ #category : #initialization }
WDCDynamicGenericMeshBuilder >> createVertexData [
	vertexData := WDCDynamicMeshInterleavedVertexData new
		data: vertices;
		vertexClass: self vertexClass;
		yourself. 
]

{ #category : #'as yet unclassified' }
WDCDynamicGenericMeshBuilder >> instantiateMesh [
	instantiatedMesh ifNil: [ instantiatedMesh := super instantiateMesh ].
	^ instantiatedMesh
]

{ #category : #accessing }
WDCDynamicGenericMeshBuilder >> mesh [
	vertices ifEmpty: [ ^ WDCNullRenderable new ].
	indices ifEmpty: [ ^ WDCNullRenderable new ].
	self finishSubmesh.
	
	^ self createMeshWithSubmeshes: submeshes asArray.
]
