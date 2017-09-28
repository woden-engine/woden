construction
reverseDepthFrustumLeft: left right: right bottom: bottom top: top near: near far: far invertedY: invertedY
	| projectionMatrix |
	projectionMatrix := WMMatrix4F reverseDepthFrustumLeft: left right: right bottom: bottom top: top near: near far: far invertedY: invertedY.
	state projectionMatrix: projectionMatrix