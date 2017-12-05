rendering preparations
updateFrameCameraStates: viewports
	| frameStates camera gpuCameraState cameraState |
	frameStates := cameraStates at: engine bufferingFrameIndex.
	viewports doWithIndex: [ :viewport :index |
		camera := viewport camera.
		cameraState := viewport cameraState.
		cameraState
			transform: (camera renderTransform transformTransform: cameraState transform);
			currentTime: currentTime.
				
		gpuCameraState := frameStates at: index.
		gpuCameraState value: cameraState.
	].

	cameraUniformBinding := cameraUniformBindings at: engine bufferingFrameIndex