initialization
createCameraStateBuffer
	self flag: 'FIXME: Move this to the camera itself'.
	cameraStatePool := WDCStreamingUniformBufferPool engine: engine elementType: WTCameraState.
	cameraStatePool heapSize: engine frameBufferingCount * self maxNumberOfCameras.
	
	cameraStates := engine frameBufferingCollect: [ :frame |
		cameraStatePool allocate: self maxNumberOfCameras
	].

	cameraUniformBindings := cameraStates collect: [ :frameStates |
		frameStates collect: [ :state |
			self shaderSignature newCameraState
				bind: 0 uniformBufferElement: state;
				yourself
		]
	].