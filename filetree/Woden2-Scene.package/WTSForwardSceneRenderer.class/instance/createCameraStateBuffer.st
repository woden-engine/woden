initialization
createCameraStateBuffer
	cameraStatePool := WTStreamingUniformBufferPool engine: engine elementType: WTCameraState.
	cameraStatePool heapSize: engine frameBufferingCount * maxNumberOfCameras.
	
	cameraStates := engine frameBufferingCollect: [ :frame |
		cameraStatePool allocate: maxNumberOfCameras
	].

	cameraUniformBindings := cameraStates collect: [ :frameStates |
		frameStates collect: [ :state |
			(engine createShaderSignature: shaderSignature resourceBinding: 1)
				bind: 0 uniformBufferElement: state;
				yourself
		]
	].
	
	"| objectStateSize cameraStateSize frameStride cameraStride baseOffset |
	objectStateSize := WMReversibleAffineTransformF structureSize alignedTo: 256.
	cameraStateSize := WTCameraState structureSize alignedTo: 256.
	cameraUniformBuffer := engine createStreamingUniformBuffer: (objectStateSize + cameraStateSize) * .

	frameStride := objectStateSize + cameraStateSize.
	cameraStride := frameStride * engine frameBufferingCount.	
	cameraUniformBindings := engine frameBufferingCollect: [ :frame |
		(0 to: maxNumberOfCameras - 1) collect: [ :i |
			baseOffset := (i * cameraStride) + ((frame - 1) * frameStride).
			(engine createShaderSignature: shaderSignature resourceBinding: 1)
				bind: 0 uniformBuffer: cameraUniformBuffer offset: baseOffset size: objectStateSize;
				bind: 1 uniformBuffer: cameraUniformBuffer offset: baseOffset + objectStateSize size: cameraStateSize;
				yourself
		].
	]"