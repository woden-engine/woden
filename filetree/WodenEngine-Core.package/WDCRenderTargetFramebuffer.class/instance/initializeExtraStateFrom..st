initialization
initializeExtraStateFrom: previousFramebuffer
	previousFramebuffer ifNil: [ ^ self ].
	
	commandAllocator := previousFramebuffer commandAllocator.
	commandList := previousFramebuffer commandList.