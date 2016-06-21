rendering
updateFrameCameraState
	| objectStateSize cameraStateSize cameraStateBuffer cameraStateBufferBaseOffset cameraState |
	objectStateSize := WMReversibleAffineTransformF structureSize alignedTo: 256.
	cameraStateSize := WTCameraState structureSize alignedTo: 256.
	cameraStateBuffer := cameraUniformBuffer validPointer getHandle.
	cameraStateBufferBaseOffset := (currentFrameIndex - 1) * (objectStateSize + cameraStateSize) + 1.
	currentCamera transform storeBytesIn: cameraStateBuffer position: cameraStateBufferBaseOffset.
	cameraState := currentCamera state copy.
	cameraState currentTime: currentTime.
	cameraState storeBytesIn: cameraStateBuffer position: cameraStateBufferBaseOffset + objectStateSize.
