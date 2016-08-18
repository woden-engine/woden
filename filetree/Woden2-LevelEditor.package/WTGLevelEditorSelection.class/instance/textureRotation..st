texture transform
textureRotation: newValue
	self textureTransformsDo: [ :transform | transform rotation: newValue ]