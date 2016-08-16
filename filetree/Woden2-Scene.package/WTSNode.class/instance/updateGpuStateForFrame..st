as yet unclassified
updateGpuStateForFrame: frameIndex
	frameIndex = lastUpdatedGpuFrame ifTrue: [ ^ self ].
	lastUpdatedGpuFrame := frameIndex.
	parent ifNotNil: [ parent updateGpuStateForFrame: frameIndex. ].
	self
		updateRenderTransform;
		performGpuStateUpdate.
