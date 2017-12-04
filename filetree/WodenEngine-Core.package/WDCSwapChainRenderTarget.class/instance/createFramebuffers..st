accessing
createFramebuffers: bufferCount
	| swapChainInfo oldFramebuffers |
	swapChainInfo := AGPUSwapChainCreateInfo new
		buffer_count: bufferCount;
		colorbuffer_format: self colorAttachmentFormats first;
		depth_stencil_format: self depthStencilFormat;
		width: width;
		height: height;
		yourself.
		
	windowHandle window ifNotNil: [ swapChainInfo window: windowHandle window ].
	windowHandle surface ifNotNil: [ swapChainInfo surface: windowHandle surface ].
	
	swapChain ifNotNil: [ swapChain release ].
	swapChain := engine device createSwapChain: engine graphicsQueue swapChainInfo: swapChainInfo.
	
	oldFramebuffers := framebuffers.
	framebuffers := (1 to: swapChain getFramebufferCount) collect: [:i |
		WDCRenderTargetFramebuffer new
			engine: engine;
			initializeExtraStateFrom: (oldFramebuffers ifNotNil: [oldFramebuffers at: i]);
			yourself
	].