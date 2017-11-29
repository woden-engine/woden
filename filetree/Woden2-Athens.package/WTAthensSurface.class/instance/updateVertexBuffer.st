private
updateVertexBuffer
	(vertexBuffer isNil or: [vertexBufferCapacity < vertices capacity]) ifTrue: [ self createVertexBuffer. ].
	LibC memCopy: vertices rawData to: vertexBuffer validPointer size: vertices rawDataSize