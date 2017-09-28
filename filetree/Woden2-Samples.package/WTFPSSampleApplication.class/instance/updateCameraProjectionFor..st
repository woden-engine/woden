rendering
updateCameraProjectionFor: aWindow
	| aspect |
	aspect := aWindow screenWidth asFloat / aWindow screenHeight asFloat.
	camera reverseDepthPerspectiveFovY: 60.0 aspect: aspect near: nearDistance far: 1000.0 invertedY: engine projectionInvertedY.