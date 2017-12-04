rendering process stages
updateCameraProjection
	| aspect target |
	target := window validRenderTarget.
	aspect := target width asFloat / target height asFloat.
	self camera reverseDepthPerspectiveFovY: 60.0 aspect: aspect near: 0.01 far: 1000.0 invertedY: engine projectionInvertedY.