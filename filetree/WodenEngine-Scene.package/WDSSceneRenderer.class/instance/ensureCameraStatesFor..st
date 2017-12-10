initialization
ensureCameraStatesFor: requiredNumberOfCameras
	| pool currentNumberOfCameras missingNumberOfCameras |
	cameraStates ifNil: [ 
		cameraStates := engine frameBufferingCollect: [ :f | #() ].
	].
	
	currentNumberOfCameras := cameraStates first size.
	missingNumberOfCameras := requiredNumberOfCameras - currentNumberOfCameras.
	
	pool := engine resourceCache streamingUniformBufferPoolFor: WTCameraState.
	
	cameraStates := cameraStates collect: [ :oldFrameStates |
		oldFrameStates , ((pool allocate: missingNumberOfCameras) collect: [ :bufferElement |
			self shaderSignature newCameraState
				bind: 0 uniformBufferElement: bufferElement;
				yourself
		])
	].