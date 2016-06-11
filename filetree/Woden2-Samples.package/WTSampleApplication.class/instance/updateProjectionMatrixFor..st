rendering
updateProjectionMatrixFor: aWindow
	| aspect w h projectionMatrix |
	aspect := aWindow screenWidth asFloat / aWindow screenHeight asFloat.
	h := 2.0.
	w := h * aspect.
	projectionMatrix := WMMatrix4F reverseDepthPerspectiveFovY: 60.0 aspect: aspect near: 0.01 far: 1000.0 invertedY: engine projectionInvertedY.
	"projectionMatrix := WMMatrix4F orthoLeft: w negated right: w bottom: h negated top: h  near: -10.0 far: 10.0 invertedY: engine projectionInvertedY."
	"Transcript show: projectionMatrix; cr."
	cameraState 
		projectionMatrix: projectionMatrix.
		
	cameraState storeBytesIn: cameraUniformBuffer validPointer getHandle position: (engine bufferingFrameIndex - 1) * (WTCameraState structureSize alignedTo: 256) + 1.
