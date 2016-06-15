rendering
updateFrameCameraState
	| objectStateSize cameraStateSize cameraStateBuffer cameraStateBufferBaseOffset |
	objectStateSize := WMReversibleAffineTransformF structureSize alignedTo: 256.
	cameraStateSize := WTCameraState structureSize alignedTo: 256.
	cameraStateBuffer := cameraUniformBuffer validPointer getHandle.
	cameraStateBufferBaseOffset := (currentFrameIndex - 1) * (objectStateSize + cameraStateSize) + 1.
	currentCamera transform storeBytesIn: cameraStateBuffer position: cameraStateBufferBaseOffset.
	currentCamera state storeBytesIn: cameraStateBuffer position: cameraStateBufferBaseOffset + objectStateSize.
