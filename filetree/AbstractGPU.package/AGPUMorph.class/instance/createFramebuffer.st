initialization
createFramebuffer
	| innerBounds colorBufferDesc hasDepth hasStencil depthStencilFormat depthStencilDesc |
	innerBounds := self innerBounds.
	screenWidth := innerBounds width asInteger.
	screenHeight := innerBounds height asInteger.
	hasDepth := self class usesDepth.
	hasStencil := self class usesStencil.
	colorBufferDesc := AGPUTextureDescription new
		type: AGPU_TEXTURE_2D;
		width: screenWidth;
		height: screenHeight;
		depthOrArraySize: 1;
		miplevels: 1;
		format: AGPU_TEXTURE_FORMAT_R8G8B8A8_UNORM;
		flags: AGPU_TEXTURE_FLAG_RENDER_TARGET.
		
	mainColorbuffer := device createTexture: colorBufferDesc initialData: NBExternalAddress null.

	mainFramebuffer := device createFrameBuffer: screenWidth height: screenHeight renderTargetCount: 1 hasDepth: hasDepth hasStencil: hasStencil.
	
	mainFramebuffer attachColorBuffer: 0 buffer: mainColorbuffer.
	
	mainFramebufferForm := Form extent: screenWidth@screenHeight depth: 32.
	
	(hasDepth or: [ hasStencil ]) ifTrue: [ 
		depthStencilFormat := hasStencil ifTrue: [ AGPU_TEXTURE_FORMAT_D24_UNORM_S8_UINT ] ifFalse: [ AGPU_TEXTURE_FORMAT_D16_UNORM ].
		depthStencilDesc := AGPUTextureDescription new
			type: AGPU_TEXTURE_2D;
			width: screenWidth;
			height: screenHeight;
			depthOrArraySize: 1;
			miplevels: 1;
			format: depthStencilFormat;
			flags: AGPU_TEXTURE_FLAG_DEPTH_STENCIL | AGPU_TEXTURE_FLAG_RENDERBUFFER_ONLY.

		mainDepthbuffer := device createTexture: depthStencilDesc initialData: NBExternalAddress null.
		mainFramebuffer attachDepthStencilBuffer: mainDepthbuffer.
	]

	