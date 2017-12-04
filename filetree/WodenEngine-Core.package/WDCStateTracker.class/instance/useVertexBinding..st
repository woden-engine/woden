commands
useVertexBinding: vertexBinding
	self vertexLayout: vertexBinding vertexLayout.
	commandListBuilder useVertexBinding: vertexBinding validHandle.
