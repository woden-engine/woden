accessing
framebuffer: newFramebuffer extent: newExtent
	frameBuffer := newFramebuffer.
	extent := newExtent.
	self computeProjectionMatrix.