initialization
createFramebufferWithColorAttachments: colorAttachments views: colorViews depthStencilAttachment: depthStencilAttachment view: depthStencilView

	| handle |
	colorAttachments ifNotEmpty: [ 
		self halt
	] ifEmpty: [ 
		handle := engine device createFrameBuffer: width height: height colorCount: 0 colorViews: nil depthStencilView: depthStencilView
	].

	^ WDCRenderTargetFramebuffer new
		engine: engine;
		colorAttachments: colorAttachments;
		depthStencilAttachment: depthStencilAttachment;
		handle: handle;
		yourself