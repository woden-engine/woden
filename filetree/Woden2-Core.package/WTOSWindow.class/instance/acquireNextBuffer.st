updating screen
acquireNextBuffer
	currentFramebuffer ifNotNil: [ currentFramebuffer release ].
	currentFramebuffer := swapChain getCurrentBackBuffer.