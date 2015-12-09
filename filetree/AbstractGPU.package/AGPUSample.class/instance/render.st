as yet unclassified
render
	commandAllocator reset.
	commandList reset: commandAllocator initial_pipeline_state: nil.
	commandList beginFrame: mainFramebuffer.
	
	commandList
		setViewport: 0 y: 0 w: screenWidth h: screenHeight;
		setScissor: 0 y: 0 w: screenWidth h: screenHeight;
		setClearColor: 0.0 g: 0.0 b: 1.0 a: 1.0;
		clear: AGPU_COLOR_BUFFER_BIT.
	
	commandList
		endFrame;
		close.
		
	commandQueue
		addCommandList: commandList;
		finishExecution.