texture transform
xTextureOffset: newValue
	self textureTransformsDo: [ :transform | transform offset: (transform offset x: newValue) ]