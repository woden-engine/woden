as yet unclassified
mesh
	vertices ifEmpty: [ ^ nil ].
	indices ifEmpty: [ ^ nil ].
	self finishSubmesh.
	
	^ self createMeshWithSubmeshes: submeshes asArray.