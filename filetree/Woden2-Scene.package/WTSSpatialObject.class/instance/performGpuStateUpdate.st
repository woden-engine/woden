rendering
performGpuStateUpdate
	| frameIndex stateSize |
	frameIndex := scene engine bufferingFrameIndex - 1.
	stateSize := WMReversibleAffineTransformF structureSize alignedTo: 256.
	transform storeBytesIn: objectStateBuffer validPointer getHandle position: frameIndex * stateSize + 1.