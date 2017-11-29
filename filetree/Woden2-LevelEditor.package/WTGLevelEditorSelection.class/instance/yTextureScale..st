texture transform
yTextureScale: newValue
	self textureTransformsDo: [ :transform | transform scale: (transform scale y: newValue) ]