rendering
compose: frameIndex colorBuffer: colorBuffer on: aWindow
	| commandList commandAllocator framebuffer w h sourceBinding |
	commandList := commandLists at: frameIndex.
	commandAllocator := commandAllocators at: frameIndex.
	framebuffer := aWindow currentFramebuffer.
	w := aWindow screenWidth.
	h := aWindow screenHeight.
	
	sourceBinding := compositionSourceBindings at: frameIndex.
	sourceBinding validHandle bindTexture: 0 texture: colorBuffer startMiplevel: 0 miplevels: -1 lodclamp: 10000.0.
	commandList withPipelineState: nil isCached: false rebuild: [ :builder |
		builder
			setShaderSignature: compositionShaderSignature handle;
			beginRenderPass: compositionRenderPass validHandle framebuffer: framebuffer bundle_content: false asBit;
			
			setViewport: 0 y: 0 w: w h: h;
			setScissor: 0 y: 0 w: w h: h;
			
			useShaderResources: sourceBinding validHandle;
			useShaderResources: compositionSamplerBindings validHandle.

		vrMode ifTrue: [ 
			builder			
				usePipelineState: compositionPipelineState validHandle;
				drawArrays: 16*16*6 instance_count: 2 first_vertex: 0 base_instance: 0.
		] ifFalse: [ 
			builder			
				usePipelineState: compositionPipelineState validHandle;
				drawArrays: 4 instance_count: 1 first_vertex: 0 base_instance: 0.
		].

		builder			
			endRenderPass.

	].
	engine graphicsQueue
		addCommandList: commandList validHandle
