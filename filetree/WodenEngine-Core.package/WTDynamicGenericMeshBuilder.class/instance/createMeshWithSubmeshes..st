as yet unclassified
createMeshWithSubmeshes: newSubmeshes
	(instantiatedMesh isNotNil and: [ newSubmeshes = instantiatedMesh submeshes ]) ifTrue: [
		self
			createVertexBuffer;
			createIndexBuffer.
		^ instantiatedMesh
	].

	^ super createMeshWithSubmeshes: newSubmeshes