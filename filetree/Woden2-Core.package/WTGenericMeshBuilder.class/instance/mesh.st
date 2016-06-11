as yet unclassified
mesh
	| mesh |
	vertices ifEmpty: [ ^ nil ].
	indices ifEmpty: [ ^ nil ].
	self finishSubmesh.
	
	mesh := WTGenericMesh new.
	mesh
		vertexBinding: self createVertexBinding;
		indexBuffer: self createIndexBuffer;
		submeshes: submeshes asArray.
	^ mesh