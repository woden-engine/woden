resource building
uploadTextureData
	| type |
	type := description type.
	type = AGPU_TEXTURE_1D ifTrue: [ ^ self uploadTexture1DData ].
	type = AGPU_TEXTURE_2D ifTrue: [ ^ self uploadTexture2DData ].
	type = AGPU_TEXTURE_CUBE ifTrue: [ ^ self uploadTextureCubeData ].
	self error: 'Not yet supported.'