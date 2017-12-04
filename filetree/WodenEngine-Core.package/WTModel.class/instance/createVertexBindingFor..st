as yet unclassified
createVertexBindingFor: anEngine
	| result vertexLayout |
	vertexLayout := anEngine vertexLayoutFor: vertices elementType behavior.
	result := anEngine createVertexBindingForLayout: vertexLayout.
	result vertexBuffers: { self createVertexBufferFor: anEngine }.
	^ result