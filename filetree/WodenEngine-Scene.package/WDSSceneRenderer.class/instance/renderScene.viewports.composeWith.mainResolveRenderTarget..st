rendering
renderScene: scene viewports: viewports composeWith: aBlock mainResolveRenderTarget: resolveRenderTarget
	| resolveFramebuffer |
	(viewports isEmpty and: [aBlock isNil]) ifTrue: [ ^ nil ].

	self prepareScene: scene renderingForViewports: viewports.	

	resolveFramebuffer := resolveRenderTarget currentFramebuffer.
	resolveFramebuffer validCommandAllocator reset.

	^ self stateTracker commandList: resolveFramebuffer validCommandList rebuildWith: [
		self setupStateTracker.
		self renderViewports: viewports composeWith: aBlock.
	].
