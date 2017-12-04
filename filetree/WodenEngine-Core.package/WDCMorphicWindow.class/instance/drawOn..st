initialization
drawOn: aCanvas
	engine ifNil: [ ^ self ].
	
	self checkSession.
	self checkRenderTarget.
	
	aCanvas translucentImage: displayForm at: self bounds origin.