drawing
drawOn: aCanvas
	engine ifNil: [ ^ self ].
	
	self checkSession.
	self checkFramebuffer.
	
	currentColorBuffer := mainColorbuffer.
	currentDepthBuffer := mainDepthbuffer. 
	currentFramebuffer := mainFramebuffer.
	application ifNotNil: [ 
		application renderOnWindow: self.
		engine graphicsQueue finishExecution
	].
	
	self blitTexture: mainColorbuffer toScreen: aCanvas