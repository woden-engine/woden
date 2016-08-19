construction
reverseDepthFrustumLeft: left right: right bottom: bottom top: top near: near far: far invertedY: invertedY
	matrix := WMMatrix4F reverseDepthFrustumLeft: left right: right bottom: bottom top: top near: near far: far invertedY: invertedY.
	self frustumLeft: left right: right bottom: bottom top: top near: near far: far.
	