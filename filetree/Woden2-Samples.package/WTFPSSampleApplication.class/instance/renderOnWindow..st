rendering
renderOnWindow: aWindow
	| frameIndex colorBuffer |
	frameIndex := engine newFrame.
	self updateCameraProjectionFor: aWindow.
	stereoMode ifTrue: [ 
		intermediateRenderTarget extent: ((aWindow screenWidth *2) @ aWindow screenHeight).
		self renderOnIntermediateTarget: intermediateRenderTarget.
	] ifFalse: [ 
		intermediateRenderTarget extent: aWindow screenExtent.
		self renderOnIntermediateTarget: intermediateRenderTarget.
	].
	colorBuffer := intermediateRenderTarget currentColorBuffer.
	intermediateRenderTarget advanceFramebuffer.
	
	self compose: frameIndex colorBuffer: colorBuffer on: aWindow