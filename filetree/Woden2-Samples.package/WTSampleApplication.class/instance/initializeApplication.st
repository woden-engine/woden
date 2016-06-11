initialization
initializeApplication
	| cameraStateSize objectStateSize meshBuilder globalLightingStateSize |
	cameraVelocity := WMVector3F new.
	cameraPosition := WMVector3F z: 3.0.
	cameraSpeed := 1.0.
	cameraState := WTCameraState new
		projectionMatrix: WMMatrix4F identity;
		inverseProjectionMatrix: WMMatrix4F identity;
		yourself.
	cameraObjectState := WTObjectState identity.
	meshObjectState := WTObjectState identity.
	
	pipelineState := engine pipelineStateNamed: #'canvas2d.polygon.convex.color.triangles.blend.over'.
	shaderSignature := engine pipelineStateManager shaderSignatureNamed: #ForwardRenderer.
	
	mainRenderPass := engine createBasicRenderPassWithColor: Color black.
	commandAllocators := engine frameBufferingCollect: [:frameId | engine createGraphicsDirectCommandListAllocator].
	commandLists := commandAllocators collect: #createListNow.
	
	objectStateSize := WTObjectState structureSize alignedTo: 256.
	objectStateBuffer := engine createStreamingUniformBuffer: objectStateSize*2.
	objectStateBindings := engine frameBufferingCollect: [ :frame |
		(engine createShaderSignature: shaderSignature resourceBinding: 0)
			bind: 0 uniformBuffer: objectStateBuffer offset: (frame - 1) * objectStateSize * 2 size: objectStateSize;
			yourself.
	].

	cameraStateSize := WTCameraState structureSize alignedTo: 256.
	cameraUniformBuffer := engine createStreamingUniformBuffer: cameraStateSize * 3.
	
	cameraUniformBindings := engine frameBufferingCollect: [ :frame |
		(engine createShaderSignature: shaderSignature resourceBinding: 1)
			bind: 0 uniformBuffer: objectStateBuffer offset: (frame - 1) * objectStateSize * 2 + objectStateSize size: objectStateSize;
			bind: 1 uniformBuffer: cameraUniformBuffer offset: (frame - 1) * cameraStateSize size: cameraStateSize;
			yourself
	].

	globalLightingState := WTGlobalLightingState new.
	globalLightingState 
		groundLighting: Color brown asWMVector4F * 0.2;
		skyLighting: Color cyan asWMVector4F * 0.2;
		sunDirection: (WMVector3F x: 0.5 y: 1.0 z: 0.3) normalized.
		
	lightSources := NativeArray for: WTLightSourceData new: 16.

	globalLightingStateSize := WTGlobalLightingState structureSize alignedTo: 256.
	globalLightingStateBuffer := engine createStreamingUniformBuffer: globalLightingStateSize * 3.
	globalLightingStateBindings := engine frameBufferingCollect: [ :frame |
		(engine createShaderSignature: shaderSignature resourceBinding: 2)
			bind: 0 uniformBuffer: globalLightingStateBuffer offset: (frame - 1) * globalLightingStateSize size: globalLightingStateSize;
			yourself
	].

	meshBuilder := WTGenericMeshBuilder for: engine.
	meshBuilder addCubeWithWidth: 1.0 height: 1.0 depth: 1.0.
	mesh := meshBuilder mesh.
