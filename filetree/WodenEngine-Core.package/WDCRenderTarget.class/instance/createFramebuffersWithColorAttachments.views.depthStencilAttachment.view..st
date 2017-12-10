accessing
createFramebuffersWithColorAttachments: colorAttachments views: colorViews depthStencilAttachment: depthStencilAttachment view: depthStencilView
	self assert: gpuOnly.
	framebuffers := {self createFramebufferWithColorAttachments: colorAttachments views: colorViews depthStencilAttachment: depthStencilAttachment view: depthStencilView}