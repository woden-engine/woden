Class {
	#name : #WDCDynamicGenericMeshBuilder,
	#superclass : #WDCGenericMeshBuilder,
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
	(indexBuffer isNil or: [ indexBufferCapacity < indices size ]) ifTrue: [
		indexBufferCapacity := indices capacity.
		indexBuffer := engine createIndex: indices elementSize streamingElements: indexBufferCapacity.
	].

	LibC memCopy: indices rawData to: indexBuffer validPointer size: indices rawDataSize.
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

{ #category : #'as yet unclassified' }
WDCDynamicGenericMeshBuilder >> createVertexBinding [
	vertexBinding ifNil: [
		vertexBinding := super createVertexBinding
	] ifNotNil: [
		vertexBinding vertexBuffers: { self createVertexBuffer }; offsets: { 0 }
	].
	^ vertexBinding
]

{ #category : #'as yet unclassified' }
WDCDynamicGenericMeshBuilder >> createVertexBuffer [
	(vertexBuffer isNil or: [ vertexBufferCapacity < vertices size ]) ifTrue: [
		vertexBufferCapacity := vertices capacity.
		vertexBuffer := engine createVertex: WTGenericVertexF structureSize streamingElements: vertexBufferCapacity.
	].

	LibC memCopy: vertices rawData to: vertexBuffer validPointer size: vertices rawDataSize.
	^ vertexBuffer
]

{ #category : #'as yet unclassified' }
WDCDynamicGenericMeshBuilder >> instantiateMesh [
	instantiatedMesh ifNil: [ instantiatedMesh := super instantiateMesh ].
	^ instantiatedMesh
]

{ #category : #'as yet unclassified' }
WDCDynamicGenericMeshBuilder >> mesh [
	self finishSubmesh.
	
	^ self createMeshWithSubmeshes: submeshes asArray.
]
