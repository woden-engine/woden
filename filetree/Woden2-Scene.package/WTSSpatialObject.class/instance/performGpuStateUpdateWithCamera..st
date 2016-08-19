rendering
performGpuStateUpdateWithCamera: aCamera
	objectState transform: renderTransform.
	self currentGpuObjectState value: objectState.
	
	renderable ifNotNil: [
		renderable performGpuStateUpdateFor: scene engine frameIndex: scene engine bufferingFrameIndex into: renderableSceneData
	]