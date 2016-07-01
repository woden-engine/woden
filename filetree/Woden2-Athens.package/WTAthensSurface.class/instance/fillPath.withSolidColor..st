rendering dispatch
fillPath: aPath withSolidColor: aColor
	aPath isJustText ifTrue: [
		^ self fillTextSegments: aPath firstSegment withSolidColor: aColor.
	].

	currentColor := aColor asWMVector4F.
	self
		addPathStencilMask: aPath;
		beginShape: AGPU_TRIANGLES pipeline: (coverColorPipeline at: blendMode);
		addBoundingBox: pathTessellatorBackend boundingBox
