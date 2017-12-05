initialization
createFramebuffer
	| colorBufferFags description colorAttachments depthStencilView depthStencilAttachment depthStencilFlags depthStencilDesc colorViews destPointer handle |
	colorBufferFags := AGPU_TEXTURE_FLAG_RENDER_TARGET.
	self gpuOnly ifTrue: [
		colorBufferFags := colorBufferFags | AGPU_TEXTURE_FLAG_RENDERBUFFER_ONLY
	] ifFalse: [
		colorBufferFags := colorBufferFags | AGPU_TEXTURE_FLAG_READED_BACK
	].
	
	colorAttachments := self colorAttachmentFormats collect: [ :format |
		description := AGPUTextureDescription new
		type: AGPU_TEXTURE_2D;
		width: width;
		height: height;
		depthOrArraySize: 1;
		miplevels: 1;
		format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB;
		flags: colorBufferFags;
		sample_count: sampleCount.
		
		(WDCTexture for: engine handle: (engine device createTexture: description))
			description: description;
			yourself
	].

	depthStencilView := nil.
	depthStencilAttachment := nil.
	(hasDepth or: [ hasStencil ]) ifTrue: [
		depthStencilFlags := AGPU_TEXTURE_FLAG_DEPTH | AGPU_TEXTURE_FLAG_RENDERBUFFER_ONLY.
		hasStencil ifTrue: [ depthStencilFlags := depthStencilFlags | AGPU_TEXTURE_FLAG_STENCIL ].
		
		depthStencilDesc := AGPUTextureDescription new
			type: AGPU_TEXTURE_2D;
			width: width;
			height: height;
			depthOrArraySize: 1;
			miplevels: 1;
			format: self depthStencilFormat;
			flags: depthStencilFlags;
			sample_count: sampleCount.
			
		depthStencilAttachment := (WDCTexture for: engine handle: (engine device createTexture: depthStencilDesc))
			description: depthStencilDesc;
			yourself.

		depthStencilView := AGPUTextureViewDescription new.
		depthStencilAttachment handle getFullViewDescription: depthStencilView.
	].

	colorAttachments ifNotEmpty: [ 
		colorViews := ExternalAddress allocate: colorAttachments size * AGPUTextureViewDescription structureSize.
		[ 
			destPointer := colorViews.
			colorAttachments do: [ :att |
				att handle getFullViewDescription: (AGPUTextureViewDescription fromHandle: destPointer).
				destPointer := destPointer + AGPUTextureViewDescription structureSize
			].
		
			handle := engine device createFrameBuffer: width height: height colorCount: colorAttachments size colorViews: (AGPUTextureViewDescription fromHandle: colorViews) depthStencilView: depthStencilView.
		] ensure: [ colorViews free ]
	] ifEmpty: [ 
		handle := engine device createFrameBuffer: width height: height colorCount: 0 colorViews: nil depthStencilView: depthStencilView.
	].

	^ WDCRenderTargetFramebuffer new
		engine: engine;
		colorAttachments: colorAttachments;
		depthStencilAttachment: depthStencilAttachment;
		handle: handle;
		yourself