initialization
drawOn: aCanvas
	self checkSession.
	self checkFramebuffer.
	
	self render.
	
	self blitTexture: mainColorbuffer toScreen: aCanvas