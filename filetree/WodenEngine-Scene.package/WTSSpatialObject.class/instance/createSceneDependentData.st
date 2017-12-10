rendering
createSceneDependentData
	| neutralInstanceState |
	gpuObjectStates ifNotNil: [ ^ self ].
	
	gpuObjectStates := scene genericObjectStatePool allocate: scene engine frameBufferingCount.
	neutralInstanceState := scene neutralGenericObjectInstanceState.
	objectStateBindings := gpuObjectStates collect: [ :state |
		scene shaderSignature newObjectState
			bind: 0 uniformBufferElement: state;
			bind: 1 storageBufferElement: neutralInstanceState;
			yourself.
	].

	renderable ifNotNil: [
		renderableSceneData := renderable createSceneDependentDataFor: scene engine into: objectStateBindings
	].
