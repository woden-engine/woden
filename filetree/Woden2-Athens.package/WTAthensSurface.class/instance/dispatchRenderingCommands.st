private
dispatchRenderingCommands
	| w h |
	self endSubmesh.
	viewportUniformData storeBytesIn: viewportUniformBuffer validPointer getHandle position: 1.
	self updateIndexBuffer.
	self updateVertexBuffer.
	self updateColorRampBuffer.
	
	w := extent x.
	h := extent y.
	
	commandAllocator reset.
	commandList reset: commandAllocator initial_pipeline_state: nil.
	[
		commandList
			setShaderSignature: shaderSignature handle;
			beginRenderPass: renderPass framebuffer: frameBuffer bundle_content: false asBit;	
			setViewport: 0 y: 0 w: w h: h;
			setScissor: 0 y: 0 w: w h: h;
			setStencilReference: 0;
			
			useVertexBinding: vertexBinding;
			useIndexBuffer: indexBuffer validHandle;
			useShaderResources: viewportUniformBinding validHandle;
			useShaderResources: samplerBindings validHandle.
		
		deferredDrawCommands do: #value.
	
		commandList endRenderPass.
	] ensure: [ commandList close ].

	commandQueue addCommandList: commandList.