as yet unclassified
createVertexBindingFor: anEngine
	| result vertexLayout vertexLayoutName |
	vertexLayoutName := vertices elementType behavior vertexLayoutName.
	vertexLayout := anEngine pipelineStateCache vertexLayoutNamed: vertexLayoutName.
	result := anEngine createVertexBindingForLayout: vertexLayout.
	result vertexBuffers: { self createVertexBufferFor: anEngine }.
	^ result