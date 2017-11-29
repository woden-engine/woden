accessing
textureExtent: anObject
	textureExtent := anObject.
	texcoordScaleFactor := WMVector2F x: 1.0 / textureExtent x y: 1.0 / textureExtent y