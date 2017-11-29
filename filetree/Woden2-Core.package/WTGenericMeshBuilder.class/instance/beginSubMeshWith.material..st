as yet unclassified
beginSubMeshWith: primitiveType material: newMaterial
	| submesh last |
	submeshes ifNotEmpty: [ 
		last := submeshes last.
		"Avoid adding submeshes."
		((last primitiveType) = primitiveType and: [ last material == newMaterial ]) ifTrue: [ ^ self ].
		self finishSubmesh
	].
	submesh := self createSubmeshObject.
	
	submesh primitiveType: primitiveType;
			material: newMaterial;
			firstIndex: indices size.
	submeshes add: submesh