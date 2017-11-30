as yet unclassified
createFramebuffers: aCount
	| depthStencilFormat depthStencilFlags depthStencilDesc colorBufferDesc device colorBuffer colorBufferView depthStencilView framebuffer depthStencilBuffer |
	framebuffers := Array new: aCount.
	colorBuffers := Array new: aCount.
	depthStencilBuffers := Array new: aCount.
	
	(hasDepth or: [ hasStencil ]) ifTrue: [ 
		depthStencilFormat := hasStencil ifTrue: [ engine preferredDepthStencilFormat ] ifFalse: [ engine preferredDepthFormat ].
		depthStencilFlags := AGPU_TEXTURE_FLAG_DEPTH | AGPU_TEXTURE_FLAG_RENDERBUFFER_ONLY.
		hasStencil ifTrue: [ depthStencilFlags := depthStencilFlags | AGPU_TEXTURE_FLAG_STENCIL ].
		
		depthStencilDesc := AGPUTextureDescription new
			type: AGPU_TEXTURE_2D;
			width: screenWidth;
			height: screenHeight;
			depthOrArraySize: 1;
			miplevels: 1;
			format: depthStencilFormat;
			flags: depthStencilFlags;
			sample_count: 1.

	] ifFalse: [
		depthStencilDesc := nil.
	].

	colorBufferDesc := AGPUTextureDescription new
		type: AGPU_TEXTURE_2D;
		width: screenWidth;
		height: screenHeight;
		depthOrArraySize: 1;
		miplevels: 1;
		format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB;
		flags: AGPU_TEXTURE_FLAG_RENDER_TARGET | AGPU_TEXTURE_FLAG_READED_BACK;
		sample_count: 1.

	device := engine device.
	1 to: aCount do: [ :i |
		colorBuffer := device createTexture: colorBufferDesc.
		colorBuffers at: i put: colorBuffer.
		colorBufferView := AGPUTextureViewDescription new.
		colorBuffer getFullViewDescription: colorBufferView.
		
		depthStencilView := nil.
		depthStencilDesc ifNotNil: [
			depthStencilBuffer := device createTexture: depthStencilDesc.
			depthStencilBuffers at: i put: depthStencilBuffer.
			depthStencilView := AGPUTextureViewDescription new.
			depthStencilBuffer getFullViewDescription: depthStencilView.
		].
	
		framebuffer := device createFrameBuffer: screenWidth height: screenHeight colorCount: 1 colorViews: colorBufferView depthStencilView: depthStencilView.
		framebuffers at: i put: framebuffer
	].