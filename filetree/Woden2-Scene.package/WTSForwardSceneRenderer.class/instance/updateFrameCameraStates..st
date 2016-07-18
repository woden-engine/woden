rendering
updateFrameCameraStates: viewports
	| frameStates camera gpuCameraState |
	frameStates := cameraStates at: currentFrameIndex.
	viewports doWithIndex: [ :viewport :index |
		camera := viewport camera.
		camera state
				transform: camera transform;
				currentTime: currentTime.
				
		gpuCameraState := frameStates at: index.
		gpuCameraState value: camera state.
	]
