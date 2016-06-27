as yet unclassified
updateGpuStateForFrame: frameIndex
	frameIndex = lastUpdatedGpuFrame ifTrue: [ ^ self ].
	parent ifNotNil: [
		parent updateGpuStateForFrame: frameIndex.
		renderTransform := parent renderTransform transformTransform: transform.
	] ifNil: [
		renderTransform := transform.
	].
	
	self performGpuStateUpdate.
	lastUpdatedGpuFrame := frameIndex.