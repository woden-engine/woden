rendering
updateProjectionMatrixFor: aWindow
	| aspect w h projectionMatrix |
	aspect := aWindow screenWidth asFloat / aWindow screenHeight asFloat.
	h := 2.0.
	w := h * aspect.
	projectionMatrix := WMMatrix4F reverseDepthPerspectiveFovY: 60.0 aspect: aspect near: 0.01 far: 1000.0 invertedY: engine projectionInvertedY.
	cameraState 
		projectionMatrix: projectionMatrix.
		
	cameraState storeBytesIn: cameraUniformBuffer validPointer getHandle position: (engine bufferingFrameIndex - 1) * (WTCameraState structureSize alignedTo: 256) + 1.
