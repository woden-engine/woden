rendering
createSceneDependentData
	| engine instanceBuffer |
	gpuObjectStates ifNotNil: [ ^ self ].
	
	engine := scene engine.
	instanceBuffer := updatedPerFrame ifFalse: [ self createInstanceStateBuffer ].
	gpuObjectStates := engine frameBufferingCollect: [:frameIndex | {
		scene genericObjectStatePool allocate.
		updatedPerFrame ifTrue: [ self createInstanceStateBuffer ] ifFalse: [ instanceBuffer ]
	}].
	
	objectStateBindings := gpuObjectStates collect: [ :state |
		| binding |
		binding := scene shaderSignature newObjectState
			bind: 0 uniformBufferElement: state first;
			bind: 1 storageBufferElement: state second;
			yourself.
		updatedPerFrame ifTrue: [
			state second reallocatedAction: [ :newVector |
				binding bind: 1 storageBufferElement: newVector
			].
		].
		binding
	].

	updatedPerFrame ifFalse: [
		instanceBuffer reallocatedAction: [ :newVector |
			engine graphicsQueue finishExecution.
			objectStateBindings do: [ :binding | binding bind: 1 storageBufferElement: newVector ]
		]
	].

	renderable ifNotNil: [
		renderableSceneData := renderable createSceneDependentDataFor: scene engine into: objectStateBindings
	].
