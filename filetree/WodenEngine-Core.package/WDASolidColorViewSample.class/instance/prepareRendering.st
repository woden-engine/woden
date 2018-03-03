rendering process stages
prepareRendering
	| resolveFramebuffer renderTarget resolveTarget renderFramebuffer |
	renderTarget :=  window validRenderTarget.
	resolveTarget := window validResolveRenderTarget.
	
	renderFramebuffer := renderTarget currentFramebuffer.
	
	resolveFramebuffer := resolveTarget currentFramebuffer.
	resolveFramebuffer validCommandAllocator reset.
	
	renderPass ifNil: [ renderPass := renderTarget createRenderPassWithColor: Color white ].
	renderPass setColorClearValue: 0 value: color asAGPUColor4f.
	
	commandList := resolveFramebuffer validCommandList.
	commandList withPipelineState: nil rebuild: [ :builder |
		builder
			beginRenderPass: renderPass validHandle framebuffer: renderFramebuffer validHandle bundle_content: false asBit;
			endRenderPass.
		renderTarget ~~ resolveTarget ifTrue: [ 
			builder resolveFramebuffer: resolveFramebuffer validHandle sourceFramebuffer: renderFramebuffer validHandle
		]
	].