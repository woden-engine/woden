rendering
updateFrameCameraStates: viewports
	| objectStateSize cameraStateSize cameraStateBuffer cameraState frameStride cameraStride baseOffset camera |
	objectStateSize := WMReversibleAffineTransformF structureSize alignedTo: 256.
	cameraStateSize := WTCameraState structureSize alignedTo: 256.
	frameStride := objectStateSize + cameraStateSize.
	cameraStride := frameStride * engine frameBufferingCount.	

	cameraStateBuffer := cameraUniformBuffer validPointer getHandle.	
	viewports doWithIndex: [ :viewport :index|
		camera := viewport camera.
		baseOffset := (cameraStride * (index - 1)) + (frameStride * (currentFrameIndex - 1)) + 1.
		camera transform storeBytesIn: cameraStateBuffer position: baseOffset.

		cameraState := camera state copy.
		cameraState currentTime: currentTime.
		cameraState storeBytesIn: cameraStateBuffer position: baseOffset + objectStateSize.
	].