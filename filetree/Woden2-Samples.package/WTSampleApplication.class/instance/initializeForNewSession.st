initialization
initializeForNewSession
	| device |
	super initializeForNewSession.
	
	device := engine device.
	mainRenderPass := self createRenderPassWithColor: Color black.
	commandAllocator := device createCommandAllocator: AGPU_COMMAND_LIST_TYPE_DIRECT queue: engine graphicsQueue .
	commandList := device createCommandList: AGPU_COMMAND_LIST_TYPE_DIRECT allocator: commandAllocator initial_pipeline_state: nil.
	commandList close.
	
	pipelineState := engine pipelineStateNamed: #'canvas2d.polygon.convex.color.triangles'.
	vertexLayout := engine pipelineStateManager vertexLayoutNamed: #CanvasVertex2D.
	shaderSignature := engine pipelineStateManager shaderSignatureNamed: #GUI.
	
	viewportUniformBuffer := self createUniformBuffer: 4*16*2
		immutableData: (WTCanvasViewport new
			projectionMatrix: (WMMatrix4F orthoLeft: -2.0 right: 2.0 bottom: -2.0 top: 2.0 near: -1.0 far: 1.0 invertedY: true);
			viewMatrix: WMMatrix4F identity) asByteArray.
	
	vertexBuffer := self createVertex: 8*4 elements: 3 immutableBuffer: #(
		"Bottom left"
		-1.0 -1.0
		0.0 0.0
		1.0 0.0 0.0 1.0
		
		"Bottom right"
		1.0 -1.0
		0.0 0.0
		0.0 0.0 1.0 1.0
		
		"Top"
		0.0 1.0
		0.0 0.0
		0.0 1.0 0.0 1.0
	) asFloatArray.
	
	indexBuffer := self createIndex: 4 elements: 3 immutableBuffer: #(
		0 1 2
	) asIntegerArray.
	
	vertexBinding := device createVertexBinding: vertexLayout handle.
	vertexBinding bindVertexBuffers: 1 vertex_buffers: vertexBuffer validHandle getHandle.
	
	viewportUniformBinding := shaderSignature handle createShaderResourceBinding: 0.
	viewportUniformBinding bindUniformBuffer: 0 uniform_buffer: viewportUniformBuffer.