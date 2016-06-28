rendering dispatch
fillPath: aPath withLinearGradient: linearGradient
	| start stop |
	start := pathTransform transform: linearGradient start.
	stop := pathTransform transform: linearGradient stop.
	currentTexcoord := WMVector2F new.
	currentColor := WMVector4F x: start x asFloat y: start y asFloat z: stop x asFloat w: stop y asFloat.
	self
		addPathStencilMask: aPath;
		beginShape: AGPU_TRIANGLES pipeline: (coverGradientPipeline at: blendMode);
		useColorRamp: linearGradient rawColorRamp;
		addBoundingBox: pathTessellatorBackend boundingBox
