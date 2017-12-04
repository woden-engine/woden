initialization
initialize
	super initialize.
	indices := SLVMNativeOrderedCollection for: #int.
	material := ''.
	textureTransform := WTGBrushFaceTextureTransform new.
	textureTransform face: self.