rendering
updateCameraProjectionFor: aWindow
	| aspect h w |
	aspect := aWindow screenWidth asFloat / aWindow screenHeight asFloat.
	h := 2.0.
	w := h * aspect.
	camera reverseDepthPerspectiveFovY: 60.0 aspect: aspect near: 0.01 far: 1000.0 invertedY: engine projectionInvertedY.