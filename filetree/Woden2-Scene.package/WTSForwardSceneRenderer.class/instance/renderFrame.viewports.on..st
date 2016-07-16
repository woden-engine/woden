rendering
renderFrame: frameIndex viewports: viewports on: framebuffer
	| commandList commandAllocator cameraUniformBinding globalLightingStateBinding backgroundColor viewportBounds |
	currentFrameIndex := frameIndex.
	commandList := commandLists at: frameIndex.
	commandAllocator := commandAllocators at: frameIndex.
	commandAllocator reset.

	currentCamera := viewports first camera.	
	self collectVisibleObjectsFor: currentCamera.
	self sortVisibleObjects.
	visibleObjects do: [ :obj | obj updateGpuStateForFrame: frameIndex ].
	
	self
		updateFrameCameraStates: viewports;
		updateFrameLightingState.
		
	cameraUniformBinding := cameraUniformBindings at: frameIndex.
	globalLightingStateBinding := globalLightingStateBindings at: frameIndex.
	
	backgroundColor := scene backgroundColor asWMVector4F.
	renderPass setColorClearValue: 0 value: (AGPUColor4f new
		r: backgroundColor x;
		g: backgroundColor y;
		b: backgroundColor z;
		a: backgroundColor w;
		yourself).
	
	commandList withPipelineState: nil rebuild: [ :builder |
		builder
				setShaderSignature: shaderSignature handle;
				useShaderResources: globalLightingStateBinding validHandle;
				useShaderResources: samplerBindings validHandle;

				beginRenderPass: renderPass validHandle framebuffer: framebuffer bundle_content: false asBit.
										
		viewports doWithIndex: [ :viewport :viewportIndex |
			viewportBounds := viewport bounds.
			builder
				setViewport: viewportBounds origin x y: viewportBounds origin y w: viewportBounds width h: viewportBounds height;
				setScissor: viewportBounds origin x y: viewportBounds origin y w: viewportBounds width h: viewportBounds height;
			
				useShaderResources: (cameraUniformBinding at: viewportIndex) validHandle.
			
				self renderObjects: visibleObjects filter: viewport filter onList: builder submode: viewport submode.
		].
	
		builder
			endRenderPass.
	].

	engine graphicsQueue
		addCommandList: commandList validHandle