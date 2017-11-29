as yet unclassified
createVertexBuffer
	(vertexBuffer isNil or: [ vertexBufferCapacity < vertices size ]) ifTrue: [
		vertexBufferCapacity := vertices capacity.
		vertexBuffer := engine createVertex: WTGenericVertexF structureSize streamingElements: vertexBufferCapacity.
	].

	LibC memCopy: vertices rawData to: vertexBuffer validPointer size: vertices rawDataSize.
	^ vertexBuffer