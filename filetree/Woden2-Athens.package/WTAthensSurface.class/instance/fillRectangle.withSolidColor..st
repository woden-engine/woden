rendering dispatch
fillRectangle: aRectangle withSolidColor: aColor
	currentColor := aColor asWMVector4F.
	self
		beginShape: AGPU_TRIANGLES pipeline: (convexColorTrianglePipeline at: blendMode);
		addTransformingBoundingBox: aRectangle asWMBox2DF
