rendering
renderFrame: frameIndex viewports: viewports on: window
	| commandList commandAllocator cameraUniformBinding globalLightingStateBinding backgroundColor viewportBounds objectsPerViewport isCommandListCached framebuffer newFrameState frameStateCache |
	currentFrameIndex := frameIndex.
	fullFrameIndex := fullFrameIndex + 1.
	self createWindowStateFor: window.
	framebuffer := window currentFramebuffer.
	commandList := self commandListFor: window at: frameIndex.
	commandAllocator := self commandAllocatorFor: window at: frameIndex.
	frameStateCache := self frameStateCacheFor: window at: frameIndex.
	
	currentCamera := viewports first camera.	
	self collectVisibleObjectsFor: currentCamera.
	visibleObjects select: [:obj | obj useViewportCamera not ] thenDo: [ :obj | obj updateGpuStateForFrame: fullFrameIndex camera: currentCamera].
	objectsPerViewport := viewports collect: [ :viewport |
		visibleObjects select: viewport filter thenCollect: [ :element |
			element useViewportCamera ifTrue: [
				element updateGpuStateForFrame: fullFrameIndex camera: viewport camera
			].
			element
		]
	].
	self sortObjects: objectsPerViewport perViewports: viewports.
	
	self
		updateFrameCameraStates: viewports;
		updateFrameLightingStates: viewports.
	
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
		objectsPerViewport collectWithIndex: [:list :i| list collect: [:node | node renderModificationCountFor: #forward submode: (viewports at: i) submode] ].
		viewports collect: #submode .
		viewports collect: #bounds .
		framebuffer validHandle getHandle asInteger
	}.
	isCommandListCached := (frameStateCache value = newFrameState) and: [ engine device isCommandListReuseSupported ~= 0].
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