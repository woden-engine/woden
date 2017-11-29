private
createVertexBuffer
	| pointerSize vertexBufferHandles |
	vertexBufferCapacity := indices capacity.
	vertexBuffer := engine createVertex: WTCanvasVertex2D structureSize streamingElements: vertexBufferCapacity.
	
	pointerSize := FFIExternalType pointerSize.
	vertexBufferHandles := ExternalAddress allocate: pointerSize.
	[
		vertexBufferHandles pointerAt: 1 put: vertexBuffer validHandle validHandle getHandle.
		vertexBinding bindVertexBuffers: 1 vertex_buffers: vertexBufferHandles.
	] ensure: [ vertexBufferHandles free ]