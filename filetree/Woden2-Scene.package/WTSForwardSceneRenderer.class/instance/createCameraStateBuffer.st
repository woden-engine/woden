initialization
createCameraStateBuffer
	| objectStateSize cameraStateSize |
	objectStateSize := WMReversibleAffineTransformF structureSize alignedTo: 256.
	cameraStateSize := WTCameraState structureSize alignedTo: 256.
	cameraUniformBuffer := engine createStreamingUniformBuffer: (objectStateSize + cameraStateSize) * engine frameBufferingCount.
	
	cameraUniformBindings := engine frameBufferingCollect: [ :frame |
		(engine createShaderSignature: shaderSignature resourceBinding: 1)
			bind: 0 uniformBuffer: cameraUniformBuffer offset: (frame - 1) * (objectStateSize + cameraStateSize) size: objectStateSize;
			bind: 1 uniformBuffer: cameraUniformBuffer offset: (frame - 1) * (objectStateSize + cameraStateSize) + objectStateSize size: cameraStateSize;
			yourself
	].