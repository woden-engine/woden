rendering
renderFrame: frameIndex camera: camera on: aWindow
	| commandList commandAllocator cameraUniformBinding globalLightingStateBinding backgroundColor |
	currentFrameIndex := frameIndex.
	commandList := commandLists at: frameIndex.
	commandAllocator := commandAllocators at: frameIndex.
	commandAllocator reset.

	currentCamera := camera.	
	self collectVisibleObjectsFor: camera.
	visibleObjects do: [ :obj | obj updateGpuStateForFrame: frameIndex ].
	
	self
		updateFrameCameraState;
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
			setViewport: 0 y: 0 w: aWindow screenWidth h: aWindow screenHeight;
			setScissor: 0 y: 0 w: aWindow screenWidth h: aWindow screenHeight;
			
			useShaderResources: cameraUniformBinding validHandle;
			useShaderResources: globalLightingStateBinding validHandle;
			
			beginRenderPass: renderPass validHandle framebuffer: aWindow currentFramebuffer bundle_content: false asBit.
			
		self renderObjects: visibleObjects onList: builder.
		
		builder		
			endRenderPass.
	].

	engine graphicsQueue
		addCommandList: commandList validHandle