rendering
renderOnWindow: aWindow
	| frameIndex commandList commandAllocator viewportUniformBinding viewportPointer |
	frameIndex := engine newFrame.
	
	self computeProjectionMatrixFor: aWindow.

	viewportPointer := viewportUniformBuffer validPointer getHandle + ((WTCanvasViewport structureSize alignedTo: 256) * (frameIndex - 1)).
	canvasViewport storeBytesIn: viewportPointer position: 1.
	
	"Transcript
		show: frameIndex; cr;
		show: viewportPointer printString; cr."
	
	commandList := commandLists at: frameIndex.
	commandAllocator := commandAllocators at: frameIndex.
	commandAllocator reset.
	
	viewportUniformBinding := viewportUniformBindings at: frameIndex.
	commandList withPipelineState: pipelineState rebuild: [ :builder |
		builder
			setShaderSignature: shaderSignature handle;
			beginRenderPass: mainRenderPass validHandle framebuffer: aWindow currentFramebuffer bundle_content: false asBit;
			
			setViewport: 0 y: 0 w: aWindow screenWidth h: aWindow screenHeight;
			setScissor: 0 y: 0 w: aWindow screenWidth h: aWindow screenHeight;
		
			useVertexBinding: vertexBinding validHandle;
			useIndexBuffer: indexBuffer validHandle;
			useShaderResources: viewportUniformBinding validHandle;
		
			drawElements: 3 instance_count: 1 first_index: 0 base_vertex: 0 base_instance: 0;
		
			endRenderPass.
	].
	
	engine graphicsQueue
		addCommandList: commandList validHandle