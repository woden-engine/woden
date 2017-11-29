as yet unclassified
createMeshWithSubmeshes: newSubmeshes
	| mesh |
	mesh := self instantiateMesh.
	mesh
		vertexBinding: self createVertexBinding;
		indexBuffer: self createIndexBuffer;
		submeshes: newSubmeshes.
	^ mesh