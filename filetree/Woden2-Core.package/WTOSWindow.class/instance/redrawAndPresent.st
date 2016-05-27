updating screen
redrawAndPresent
	engine ifNil: [ ^ self ].
	self checkSwapChain.
	self acquireNextBuffer.
	application ifNotNil: [ 
		application renderOnWindow: self.
	].

	self present.