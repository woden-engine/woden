texture transform
yTextureOffset: newValue
	self textureTransformsDo: [ :transform | transform offset: (transform offset y: newValue) ]