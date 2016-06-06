initialization
initializeApplication
	| canvasViewportSize |
	canvasViewport := WTCanvasViewportUniformData new
		viewMatrix: WMMatrix4F identity;
		projectionMatrix: WMMatrix4F identity.
	pipelineState := engine pipelineStateNamed: #'canvas2d.polygon.convex.color.triangles.blend.over'.
	vertexLayout := engine pipelineStateManager vertexLayoutNamed: #CanvasVertex2D.
	shaderSignature := engine pipelineStateManager shaderSignatureNamed: #GUI.
	
	mainRenderPass := engine createBasicRenderPassWithColor: Color black.
	commandAllocators := engine frameBufferingCollect: [:frameId | engine createGraphicsDirectCommandListAllocator].
	commandLists := commandAllocators collect: #createListNow.
	
	canvasViewportSize := WTCanvasViewportUniformData structureSize alignedTo: 256.
	viewportUniformBuffer := engine createStreamingUniformBuffer: canvasViewportSize * 3.
	
	viewportUniformBindings := engine frameBufferingCollect: [ :frame |
		(engine createShaderSignature: shaderSignature resourceBinding: 0)
			bind: 0 uniformBuffer: viewportUniformBuffer offset: (frame - 1) * canvasViewportSize size: canvasViewportSize;
			yourself
	].

	vertexBuffer := engine createVertex: 8*4 elements: 3 immutableBuffer: #(
		"Bottom left"
		-1.0 -1.0
		0.0 0.0
		0.0 1.0 0.0 1.0
		
		"Bottom right"
		1.0 -1.0
		0.0 0.0
		1.0 0.0 0.0 1.0
		
		"Top"
		0.0 1.0
		0.0 0.0
		0.0 0.0 1.0 1.0
	) asFloatArray.
	
	indexBuffer := engine createIndex: 4 elements: 3 immutableBuffer: #(
		0 1 2
	) asIntegerArray.
	
	vertexBinding := engine createVertexBindingForLayout: vertexLayout.
	vertexBinding vertexBuffers: { vertexBuffer }.
