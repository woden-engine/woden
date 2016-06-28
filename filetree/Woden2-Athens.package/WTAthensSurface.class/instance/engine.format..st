initialization
engine: aWTEngine format: aTextureFormat
	engine := aWTEngine.
	colorBufferFormat := aTextureFormat.
	useOwnFramebuffer := false.
	self initializeForNewSession.