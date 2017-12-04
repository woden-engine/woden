rendering preparations
updateFrameCameraStates: viewports
	| frameStates camera gpuCameraState |
	frameStates := cameraStates at: engine bufferingFrameIndex.
	viewports doWithIndex: [ :viewport :index |
		camera := viewport camera.
		camera state
				transform: camera renderTransform;
				currentTime: currentTime.
				
		gpuCameraState := frameStates at: index.
		gpuCameraState value: camera state.
	].

	cameraUniformBinding := cameraUniformBindings at: engine bufferingFrameIndex