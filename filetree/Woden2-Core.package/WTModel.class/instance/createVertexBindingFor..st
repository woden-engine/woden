as yet unclassified
createVertexBindingFor: anEngine
	| result vertexLayout |
	vertexLayout := anEngine pipelineStateCache vertexLayoutNamed: #GenericVertex.
	result := anEngine createVertexBindingForLayout: vertexLayout.
	result vertexBuffers: { self createVertexBufferFor: anEngine }.
	^ result