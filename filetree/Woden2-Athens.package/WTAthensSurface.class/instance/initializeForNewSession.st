initialization
initializeForNewSession
	| device stateManager canvasViewportSize |
	engine checkSession.
	device := engine device.
	stateManager := engine pipelineStateCache.
	vertexLayout := stateManager vertexLayoutNamed: #CanvasVertex2D.
	shaderSignature := stateManager shaderSignatureNamed: #GUI.
	convexColorLinePipeline := self loadStateWithBlendVariants: #'canvas2d.polygon.convex.color.lines'.
	convexColorTrianglePipeline := self loadStateWithBlendVariants: #'canvas2d.polygon.convex.color.triangles'.
	
	stencilNonZeroPipeline := stateManager pipelineStateNamed: #'canvas2d.polygon.stencil.non-zero'.
	stencilEvenOddPipeline := stateManager pipelineStateNamed: #'canvas2d.polygon.stencil.even-odd'.
	coverColorPipeline := self loadStateWithBlendVariants: #'canvas2d.polygon.cover.color'.
	
	textColorPipeline := stateManager pipelineStateNamed: #'canvas2d.text.color'.
	textSdfColorPipeline := stateManager pipelineStateNamed: #'canvas2d.textsdf.color'.
	
	vertexBinding := device createVertexBinding: vertexLayout handle.
	
	synchronizationFence := nil.
	commandQueue := engine graphicsQueue.
	commandAllocator := device createCommandAllocator: AGPU_COMMAND_LIST_TYPE_DIRECT queue: commandQueue.
	commandList := device createCommandList: AGPU_COMMAND_LIST_TYPE_DIRECT allocator: commandAllocator initial_pipeline_state: nil.
	commandList close.
	
	canvasViewportSize := WTCanvasViewportUniformData structureSize alignedTo: 256.
	viewportUniformBuffer := engine createStreamingUniformBuffer: canvasViewportSize * 3.
	viewportUniformBinding := (engine createShaderSignature: shaderSignature resourceBinding: 0)
			bind: 0 uniformBuffer: viewportUniformBuffer offset: 0 size: canvasViewportSize;
			yourself.
	
	vertexBuffer := nil.
	indexBuffer := nil.
	self createSamplers.
	self createFrameBuffer.
	self createRenderPass.
	self computeProjectionMatrix.
	session := Smalltalk session.
