rendering
performGpuStateUpdate
	| frameIndex stateSize |
	frameIndex := scene engine bufferingFrameIndex - 1.
	stateSize := WMReversibleAffineTransformF structureSize alignedTo: 256.
	renderTransform storeBytesIn: objectStateBuffer validPointer getHandle position: frameIndex * stateSize + 1.
	
	renderable ifNotNil: [
		renderable performGpuStateUpdateFor: scene engine frameIndex: frameIndex + 1 into: renderableSceneData
	]