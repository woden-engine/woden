as yet unclassified
updateGpuStateForFrame: frameIndex camera: currentCamera
	frameIndex = lastUpdatedGpuFrame ifTrue: [ ^ self ].
	lastUpdatedGpuFrame := frameIndex.
	parent ifNotNil: [ parent updateGpuStateForFrame: frameIndex camera: currentCamera ].
	self
		updateRenderTransform;
		performGpuStateUpdateWithCamera: currentCamera.
