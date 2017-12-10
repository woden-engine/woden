rendering preparations
updateFrameCameraStates: viewports
	| gpuCameraState cameraState |
	self ensureCameraStatesFor: viewports size.
	currentCameraStates := cameraStates at: engine bufferingFrameIndex.
	viewports doWithIndex: [ :viewport :index |
		cameraState := viewport cameraState.
		cameraState
			transform: viewport cameraTransform;
			currentTime: currentTime.
				
		gpuCameraState := (currentCameraStates at: index) slotValueAt: 0.
		gpuCameraState value: cameraState.
	].
