initialization
initialize
	super initialize.
	indices := NativeOrderedCollection for: #int.
	material := ''.
	material := 'materials/demos/tile.json'.
	textureTransform := WTGBrushFaceTextureTransform new.
	textureTransform face: self.