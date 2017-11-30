factory
createSwapChain
	| hasDepth hasStencil  depthStencilFormat windowExtent swapChainInfo |
	hasDepth := application usesDepth.
	hasStencil := application usesStencil.
	windowHandle := window platformSpecificHandle .
	(hasDepth or: [ hasStencil ]) ifTrue: [ 
		depthStencilFormat := hasStencil ifTrue: [ engine preferredDepthStencilFormat ] ifFalse: [ engine preferredDepthFormat ].
	] ifFalse: [
		depthStencilFormat := AGPU_TEXTURE_FORMAT_UNKNOWN.
	].

	windowExtent := window extent.
	screenWidth := windowExtent x.
	screenHeight := windowExtent y.
	swapChainInfo := AGPUSwapChainCreateInfo new
		buffer_count: engine frameBufferingCount;
		colorbuffer_format: AGPU_TEXTURE_FORMAT_B8G8R8A8_UNORM_SRGB;
		depth_stencil_format: depthStencilFormat;
		width: screenWidth;
		height: screenHeight;
		yourself.
		
	windowHandle window ifNotNil: [ swapChainInfo window: windowHandle window ].
	windowHandle surface ifNotNil: [ swapChainInfo surface: windowHandle surface ].
	swapChain := engine device createSwapChain: engine graphicsQueue swapChainInfo: swapChainInfo.
	self assert: swapChain handle isNull not.