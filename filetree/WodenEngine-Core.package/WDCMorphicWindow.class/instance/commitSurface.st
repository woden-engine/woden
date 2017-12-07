rendering
commitSurface
	| pitch slicePitch |
	pitch := displayForm width * 4.
	slicePitch := pitch * displayForm height.
	displayForm unhibernate.
	
	engine graphicsQueue finishExecution.
	resolveRenderTarget currentFramebuffer colorAttachments first validHandle
		readTextureData: 0 arrayIndex: 0 pitch: pitch slicePitch: slicePitch buffer: displayForm bits.
	self changed