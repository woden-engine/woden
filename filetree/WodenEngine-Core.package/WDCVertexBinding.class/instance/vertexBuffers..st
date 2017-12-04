accessing
vertexBuffers: anObject
	vertexBuffers := anObject.
	self hasValidHandle ifTrue: [ self bindVertexBuffers ].