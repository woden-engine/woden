as yet unclassified
createVertexBinding
	vertexBinding ifNil: [
		vertexBinding := super createVertexBinding
	] ifNotNil: [
		vertexBinding vertexBuffers: { self createVertexBuffer }
	].
	^ vertexBinding