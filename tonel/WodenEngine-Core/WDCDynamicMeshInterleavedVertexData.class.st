Class {
	#name : #WDCDynamicMeshInterleavedVertexData,
	#superclass : #WDCMeshInterleavedVertexData,
	#instVars : [
		'vertexBinding',
		'vertexBuffer',
		'vertexBufferCapacity'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #'as yet unclassified' }
WDCDynamicMeshInterleavedVertexData >> createVertexBindingFor: anEngine [
	vertexBinding ifNil: [
		vertexBinding := super createVertexBindingFor: anEngine
	] ifNotNil: [
		vertexBinding vertexBuffers: { self createVertexBufferFor: anEngine }; offsets: { 0 }
	].
	^ vertexBinding
]

{ #category : #'as yet unclassified' }
WDCDynamicMeshInterleavedVertexData >> createVertexBufferFor: anEngine [
	(vertexBuffer isNil or: [ vertexBufferCapacity < data capacity ]) ifTrue: [
		vertexBufferCapacity := data capacity.
		vertexBuffer := anEngine createVertex: WDCGenericVertexF32 instanceSize streamingElements: vertexBufferCapacity.
	].

	LibC memCopy: data rawData to: vertexBuffer validPointer size: data rawDataSize.
	^ vertexBuffer
]
