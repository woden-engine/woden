as yet unclassified
fillPath: aPath withSolidColor: aColor
	currentColor := aColor asWMVector4F.
	self
		addPathStencilMask: aPath;
		beginShape: AGPU_TRIANGLES pipeline: (coverColorPipeline at: blendMode);
		addBoundingBox: pathTessellatorBackend boundingBox
