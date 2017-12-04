accessing
currentFramebuffer
	| result |
	result := framebuffers at: swapChain getCurrentBackBufferIndex + 1.
	result handle ifNil: [ result handle: swapChain getCurrentBackBuffer ].
	^ result