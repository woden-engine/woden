initialization
initialize
	super initialize.
	indices := NativeOrderedCollection for: #int.
	material := ''.
	textureTransform := WTGBrushFaceTextureTransform new.
	textureTransform face: self.