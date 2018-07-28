Class {
	#name : #WDCVertexBinding,
	#superclass : #WDCResourceWithSessionHandle,
	#instVars : [
		'vertexLayout',
		'vertexBuffers',
		'offsets'
	],
	#category : #'WodenEngine-Core-GPU-Resources'
}

{ #category : #'as yet unclassified' }
WDCVertexBinding >> bindVertexBuffers [
	| pointerSize vertexBufferHandles offsetsBuffer |
	vertexBuffers ifNil: [ ^ self ].
	
	pointerSize := FFIExternalType pointerSize.
	vertexBufferHandles := ExternalAddress allocate: pointerSize * vertexBuffers size.
	offsetsBuffer := ByteArray new: 4*vertexBuffers size.
	[
		1 to: vertexBuffers size do: [ :i |
			vertexBufferHandles pointerAt: 1 + ((i-1) * pointerSize) put: (vertexBuffers at: i) validHandle validHandle getHandle.
			offsetsBuffer unsignedLongAt: 1 + ((i-1) * 4) put: (self offsets at: i)
		].

		handle bindVertexBuffersWithOffsets: vertexBuffers size vertex_buffers: vertexBufferHandles offsets: offsetsBuffer.
	] ensure: [ vertexBufferHandles free ]
]

{ #category : #'as yet unclassified' }
WDCVertexBinding >> buildHandle [
	handle := engine device createVertexBinding: vertexLayout handle.
	self bindVertexBuffers.
]

{ #category : #accessing }
WDCVertexBinding >> offsets [
	^ offsets ifNil: [ offsets := (1 to: vertexBuffers size) collect: [ :i | 0 ] ]
]

{ #category : #accessing }
WDCVertexBinding >> offsets: anObject [
	offsets := anObject.
	self hasValidHandle ifTrue: [ self bindVertexBuffers ].
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
WDCVertexBinding >> vertexBuffers: newVertexBuffers offsets: newOffsets [
	vertexBuffers := newVertexBuffers.
	offsets := newOffsets.
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
