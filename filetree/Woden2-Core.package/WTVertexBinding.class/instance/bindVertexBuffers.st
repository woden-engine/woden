as yet unclassified
bindVertexBuffers
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