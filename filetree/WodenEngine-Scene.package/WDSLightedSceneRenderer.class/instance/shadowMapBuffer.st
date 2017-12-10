shadow mapping
shadowMapBuffer
	| shadowMapExtent description shadowMapFormat view subresourceRange |
	shadowMapBuffer ifNotNil: [ ^ shadowMapBuffer ].
	shadowMapExtent := self shadowMapExtent.
	
	shadowMapFormat := engine preferredDepthFormat.
	description := AGPUTextureDescription new
		type: AGPU_TEXTURE_2D;
		format: shadowMapFormat;
		width: shadowMapExtent x;
		height: shadowMapExtent y;
		depthOrArraySize: self maxShadowCastingLightCount;
		miplevels: 1;
		sample_count: 1;
		sample_quality: 0;
		flags: AGPU_TEXTURE_FLAG_RENDERBUFFER_ONLY | AGPU_TEXTURE_FLAG_DEPTH |AGPU_TEXTURE_FLAG_RENDER_TARGET;
		yourself.
		
	shadowMapBuffer := (WDCTexture for: engine)
			description: description;
			checkSession;
			yourself.

	view := AGPUTextureViewDescription new.
	shadowMapBuffer validHandle getFullViewDescription: view.
	
	subresourceRange := view subresource_range.
	subresourceRange layer_count: 1.
	
	shadowMapRenderTargets := (1 to: self maxShadowCastingLightCount) collect: [ :i |
		subresourceRange base_arraylayer: i - 1.
		(WDCRenderTarget for: engine extent: shadowMapExtent)
			colorAttachmentFormats: #();
			depthStencilFormat: shadowMapFormat;
			hasDepth: true;
			createFramebuffersWithColorAttachments: #() views: #() depthStencilAttachment: shadowMapBuffer view: view;
			yourself
	].
	
	^ shadowMapBuffer