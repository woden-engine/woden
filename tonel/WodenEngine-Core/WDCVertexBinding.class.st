Class {
	#name : #WDCVertexBinding,
	#superclass : #WDCResourceWithSessionHandle,
	#instVars : [
		'vertexLayout',
		'vertexBuffers'
	],
	#category : 'WodenEngine-Core-GPU-Resources'
}

{ #category : #'as yet unclassified' }
WDCVertexBinding >> bindVertexBuffers [
	| pointerSize vertexBufferHandles |
	vertexBuffers ifNil: [ ^ self ].
	
	pointerSize := FFIExternalType pointerSize.
	vertexBufferHandles := ExternalAddress allocate: pointerSize * vertexBuffers size.
	[
		1 to: vertexBuffers size do: [ :i |
			vertexBufferHandles pointerAt: 1 + ((i-1) * pointerSize) put: (vertexBuffers at: i) validHandle validHandle getHandle
		].

		handle bindVertexBuffers: vertexBuffers size vertex_buffers: vertexBufferHandles.
	] ensure: [ vertexBufferHandles free ]
]

{ #category : #'as yet unclassified' }
WDCVertexBinding >> buildHandle [
	handle := engine device createVertexBinding: vertexLayout handle.
	self bindVertexBuffers.
]

{ #category : #accessing }
WDCVertexBinding >> vertexBuffers [
	^ vertexBuffers
]

{ #category : #accessing }
WDCVertexBinding >> vertexBuffers: anObject [
	vertexBuffers := anObject.
	self hasValidHandle ifTrue: [ self bindVertexBuffers ].
]

{ #category : #accessing }
WDCVertexBinding >> vertexLayout [
	^ vertexLayout
]

{ #category : #accessing }
WDCVertexBinding >> vertexLayout: anObject [
	vertexLayout := anObject
]
