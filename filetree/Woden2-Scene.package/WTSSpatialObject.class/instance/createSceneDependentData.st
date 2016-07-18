rendering
createSceneDependentData
	gpuObjectStates ifNotNil: [ ^ self ].
	
	gpuObjectStates := scene genericObjectStatePool allocate: scene engine frameBufferingCount.
	objectStateBindings := gpuObjectStates collect: [ :state |
		(scene engine createShaderSignature: scene shaderSignature resourceBinding: 0)
			bind: 0 uniformBufferElement: state;
			yourself.
	].

	renderable ifNotNil: [
		renderableSceneData := renderable createSceneDependentDataFor: scene engine into: objectStateBindings
	].
