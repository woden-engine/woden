texture transform
xTextureScale: newValue
	self textureTransformsDo: [ :transform | transform scale: (transform scale x: newValue) ]