rendering dispatch
fillPath: aPath withRadialGradient: radialGradient
	| center focalPoint |
	center := radialGradient center.
	focalPoint := radialGradient focalPoint.
	currentTexcoord := WMVector2F x: 1.0 y: radialGradient radius asFloat.
	currentColor := WMVector4F x: center x asFloat y: center y asFloat z: focalPoint x asFloat w: focalPoint y asFloat.
	self
		addPathStencilMask: aPath;
		beginShape: AGPU_TRIANGLES pipeline: (coverGradientPipeline at: blendMode);
		useColorRamp: radialGradient rawColorRamp;
		addBoundingBox: pathTessellatorBackend boundingBox
