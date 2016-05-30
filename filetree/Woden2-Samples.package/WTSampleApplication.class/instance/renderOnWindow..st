rendering
renderOnWindow: aWindow
	engine newFrame.
	
	commandList 
		reset: commandAllocator initial_pipeline_state: pipelineState handle;
		setShaderSignature: shaderSignature handle;
		beginRenderPass: mainRenderPass framebuffer: aWindow currentFramebuffer bundle_content: false asBit.
	
	commandList
		setViewport: 0 y: 0 w: aWindow screenWidth h: aWindow screenHeight;
		setScissor: 0 y: 0 w: aWindow screenWidth h: aWindow screenHeight;
		
		useVertexBinding: vertexBinding;
		useIndexBuffer: indexBuffer;
		useShaderResources: viewportUniformBinding;
		
		drawElements: 3 instance_count: 1 first_index: 0 base_vertex: 0 base_instance: 0;
		
		endRenderPass;
		close.
		
	engine graphicsQueue
		addCommandList: commandList