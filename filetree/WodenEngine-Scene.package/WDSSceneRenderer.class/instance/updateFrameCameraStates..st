rendering preparations
updateFrameCameraStates: viewports
	| frameStates gpuCameraState cameraState |
	frameStates := cameraStates at: engine bufferingFrameIndex.
	viewports doWithIndex: [ :viewport :index |
		cameraState := viewport cameraState.
		cameraState
			transform: viewport cameraTransform;
			currentTime: currentTime.
				
		gpuCameraState := frameStates at: index.
		gpuCameraState value: cameraState.
	].

	cameraUniformBinding := cameraUniformBindings at: engine bufferingFrameIndex