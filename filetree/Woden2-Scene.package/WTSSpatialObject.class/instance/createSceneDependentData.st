rendering
createSceneDependentData
	"TODO: Create an allocator that allocates big buffers, and then sub-allocates the object data."
	| objectStateSize |
	objectStateBuffer ifNotNil: [ ^ self ].
	
	objectStateSize := WTGenericObjectState structureSize alignedTo: 256.
	objectStateBuffer := scene engine createStreamingUniformBuffer: objectStateSize * scene engine frameBufferingCount.
	objectStateBindings := scene engine frameBufferingCollect: [ :frame |
		(scene engine createShaderSignature: scene shaderSignature resourceBinding: 0)
			bind: 0 uniformBuffer: objectStateBuffer offset: (frame - 1) * objectStateSize size: objectStateSize;
			yourself.
	].

	renderable ifNotNil: [
		renderableSceneData := renderable createSceneDependentDataFor: scene engine into: objectStateBindings
	].
