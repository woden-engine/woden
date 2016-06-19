initialization
createFramebuffer
	| innerBounds colorBufferDesc hasDepth hasStencil depthStencilFormat depthStencilDesc mainColorbufferView mainDepthbufferView device depthStencilFlags |
	device := engine device.
	innerBounds := self innerBounds.
	screenWidth := innerBounds width asInteger.
	screenHeight := innerBounds height asInteger.
	hasDepth := application usesDepth.
	hasStencil := application usesStencil.
	colorBufferDesc := AGPUTextureDescription new
		type: AGPU_TEXTURE_2D;
		width: screenWidth;
		height: screenHeight;
		depthOrArraySize: 1;
		miplevels: 1;
		format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB;
		flags: AGPU_TEXTURE_FLAG_RENDER_TARGET | AGPU_TEXTURE_FLAG_READED_BACK;
		sample_count: 1.
	mainColorbuffer := device createTexture: colorBufferDesc.
	
	mainColorbufferView := AGPUTextureViewDescription new.
	mainColorbuffer getFullViewDescription: mainColorbufferView.

	mainDepthbufferView := nil.
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
		hasStencil ifTrue: [
			depthStencilDesc flags: depthStencilDesc flags | AGPU_TEXTURE_FLAG_STENCIL
		].

		mainDepthbuffer := device createTexture: depthStencilDesc.
		mainDepthbufferView := AGPUTextureViewDescription new.
		mainDepthbuffer getFullViewDescription: mainDepthbufferView.
	].

	mainFramebuffer := device createFrameBuffer: screenWidth height: screenHeight colorCount: 1 colorViews: mainColorbufferView depthStencilView: mainDepthbufferView.
	mainFramebufferForm := Form extent: screenWidth@screenHeight depth: 32.
		