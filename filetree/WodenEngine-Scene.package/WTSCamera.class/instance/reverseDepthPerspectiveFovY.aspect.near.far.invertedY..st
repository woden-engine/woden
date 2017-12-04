construction
reverseDepthPerspectiveFovY: fovy aspect: aspect near: near far: far invertedY: invertedY
	| projectionMatrix |
	projectionMatrix := WMMatrix4F reverseDepthPerspectiveFovY: fovy aspect: aspect near: near far: far invertedY: invertedY.
	state projectionMatrix: projectionMatrix