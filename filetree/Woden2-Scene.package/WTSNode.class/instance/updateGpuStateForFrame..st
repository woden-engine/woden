as yet unclassified
updateGpuStateForFrame: frameIndex
	frameIndex = lastUpdatedGpuFrame ifTrue: [ ^ self ].
	self performGpuStateUpdate.
	lastUpdatedGpuFrame := frameIndex.