rendering
performGpuStateUpdate
	| frameIndex stateSize |
	frameIndex := scene engine bufferingFrameIndex - 1.
	stateSize := WMReversibleAffineTransformF structureSize alignedTo: 256.
	renderTransform storeBytesIn: objectStateBuffer validPointer getHandle position: frameIndex * stateSize + 1.