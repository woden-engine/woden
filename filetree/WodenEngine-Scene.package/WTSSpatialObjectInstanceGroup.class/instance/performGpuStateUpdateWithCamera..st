rendering
performGpuStateUpdateWithCamera: aCamera
	| currentGpuState instanceStateBuffer instanceStateSize instanceStateOffset instanceStatePointer |
	objectState transform: renderTransform.
	depthSorted ifTrue: [ self depthSortFor: aCamera ].
	
	currentGpuState := self currentGpuObjectState.
	currentGpuState first value: objectState.
	
	instanceStateBuffer := currentGpuState second.
	instanceStateBuffer ensureCapacityForAtLeast: children size keepOldData: true.
	
	instanceStateSize := instanceStateBuffer elementSize.
	instanceStatePointer := instanceStateBuffer validPointer getHandle.
	updatedPerFrame ifTrue: [ 
		children doWithIndex: [ :child :index |
			instanceStateOffset := (index-1) * instanceStateSize.
			child writeGPUStateInto: instanceStatePointer at: instanceStateOffset
		].
	] ifFalse: [
		pendingUpdates do: [ :child |
			instanceStateOffset := childOffsetDictionary at: child.
			child writeGPUStateInto: instanceStatePointer at: instanceStateOffset			
		].
		pendingUpdates removeAll
	].
	
	renderable ifNotNil: [
		renderable performGpuStateUpdateFor: scene engine frameIndex: scene engine bufferingFrameIndex into: renderableSceneData
	]