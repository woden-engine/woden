accessing
textureTransform: aTextureTransform
	textureTransform ifNotNil: [ textureTransform face: nil ].
	textureTransform := aTextureTransform copy.
	textureTransform ifNotNil: [ textureTransform face: self ].
	self invalidateTexturedModel.