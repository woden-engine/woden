rendering
currentGpuObjectState
	gpuObjectStates ifNil: [ self createSceneDependentData ].
	^ gpuObjectStates at: scene engine bufferingFrameIndex