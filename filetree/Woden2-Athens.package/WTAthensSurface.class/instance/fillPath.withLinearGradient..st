rendering dispatch
fillPath: aPath withLinearGradient: linearGradient
	| start stop |
	start := linearGradient start.
	stop := linearGradient stop.
	currentTexcoord := WMVector2F new.
	currentColor := WMVector4F x: start x asFloat y: start y asFloat z: stop x asFloat w: stop y asFloat.
	self
		addPathStencilMask: aPath;
		beginShape: AGPU_TRIANGLES pipeline: (coverGradientPipeline at: blendMode);
		useColorRamp: linearGradient rawColorRamp;
		addBoundingBox: pathTessellatorBackend boundingBox
