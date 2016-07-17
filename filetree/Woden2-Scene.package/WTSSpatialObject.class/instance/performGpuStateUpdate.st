rendering
performGpuStateUpdate
	| frameIndex stateSize |
	objectStateBuffer ifNil: [ self createSceneDependentData ].
	
	frameIndex := scene engine bufferingFrameIndex - 1.
	stateSize := objectState class structureSize alignedTo: 256.
	objectState transform: renderTransform.
	objectState storeBytesIn: objectStateBuffer validPointer getHandle position: frameIndex * stateSize + 1.
	
	renderable ifNotNil: [
		renderable performGpuStateUpdateFor: scene engine frameIndex: frameIndex + 1 into: renderableSceneData
	]