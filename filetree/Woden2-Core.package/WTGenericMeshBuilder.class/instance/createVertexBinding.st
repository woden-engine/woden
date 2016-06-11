as yet unclassified
createVertexBinding
	| result |
	result := engine createVertexBindingForLayout: vertexLayout.
	result vertexBuffers: { self createVertexBuffer }.
	^ result