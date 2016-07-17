rendering
renderFrame: frameIndex viewports: viewports on: window
	| commandList commandAllocator cameraUniformBinding globalLightingStateBinding backgroundColor viewportBounds objectsPerViewport isCommandListCached framebuffer newFrameState frameStateCache |
	currentFrameIndex := frameIndex.
	self createWindowStateFor: window.
	framebuffer := window currentFramebuffer.
	commandList := self commandListFor: window at: frameIndex.
	commandAllocator := self commandAllocatorFor: window at: frameIndex.
	frameStateCache := self frameStateCacheFor: window at: frameIndex.
	
	currentCamera := viewports first camera.	
	self collectVisibleObjectsFor: currentCamera.
	self sortVisibleObjects.
	visibleObjects do: [ :obj | obj updateGpuStateForFrame: frameIndex ].
	
	self
		updateFrameCameraStates: viewports;
		updateFrameLightingStates: viewports.
		
	objectsPerViewport := viewports collect: [ :viewport | visibleObjects select: viewport filter ].
	
	cameraUniformBinding := cameraUniformBindings at: frameIndex.
	globalLightingStateBinding := globalLightingStateBindings at: frameIndex.
	
	backgroundColor := scene backgroundColor asWMVector4F.
	renderPass setColorClearValue: 0 value: (AGPUColor4f new
		r: backgroundColor x;
		g: backgroundColor y;
		b: backgroundColor z;
		a: backgroundColor w;
		yourself).

	newFrameState := {
		objectsPerViewport .
		objectsPerViewport collect: [:list | list collect: #renderModificationCount ].
		viewports collect: #submode .
		viewports collect: #bounds .
		framebuffer validHandle getHandle asInteger
	}.
	isCommandListCached := frameStateCache value = newFrameState.
	frameStateCache value: newFrameState.
	isCommandListCached ifFalse: [ commandAllocator reset. ].
	
	commandList withPipelineState: nil isCached: isCommandListCached rebuild: [ :builder |
		builder
			beginRenderPass: renderPass validHandle framebuffer: framebuffer bundle_content: false asBit.
	
		viewports doWithIndex: [ :viewport :viewportIndex |
			viewportBounds := viewport bounds.
			builder
				setViewport: viewportBounds origin x y: viewportBounds origin y w: viewportBounds width h: viewportBounds height;
				setScissor: viewportBounds origin x y: viewportBounds origin y w: viewportBounds width h: viewportBounds height;

				setShaderSignature: shaderSignature handle;
				useShaderResources: samplerBindings validHandle;
											
				useShaderResources: (cameraUniformBinding at: viewportIndex) validHandle;
				useShaderResources: (globalLightingStateBinding at: viewportIndex) validHandle.
			
				(objectsPerViewport at: viewportIndex) do: [ :object | object renderOn: builder mode: #forward submode: viewport submode ]
		].	
		builder
			endRenderPass.
	].

	engine graphicsQueue
		addCommandList: commandList validHandle