rendering
renderScene: scene viewports: viewports
	| resolveFramebuffer |
	viewports ifEmpty: [ ^ nil ].

	self prepareScene: scene renderingForViewports: viewports.	

	resolveFramebuffer := viewports first resolveRenderTarget currentFramebuffer.
	resolveFramebuffer validCommandAllocator reset.

	^ self stateTracker commandList: resolveFramebuffer validCommandList rebuildWith: [
		self setupStateTracker.
		self renderViewports: viewports.
	].
