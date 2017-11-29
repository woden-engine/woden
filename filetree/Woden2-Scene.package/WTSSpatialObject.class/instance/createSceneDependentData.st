rendering
createSceneDependentData
	| neutralInstanceState |
	gpuObjectStates ifNotNil: [ ^ self ].
	
	gpuObjectStates := scene genericObjectStatePool allocate: scene engine frameBufferingCount.
	neutralInstanceState := scene neutralGenericObjectInstanceState.
	objectStateBindings := gpuObjectStates collect: [ :state |
		(scene engine createShaderSignature: scene shaderSignature resourceBinding: 0)
			bind: 0 uniformBufferElement: state;
			bind: 1 storageBufferElement: neutralInstanceState;
			yourself.
	].

	renderable ifNotNil: [
		renderableSceneData := renderable createSceneDependentDataFor: scene engine into: objectStateBindings
	].
