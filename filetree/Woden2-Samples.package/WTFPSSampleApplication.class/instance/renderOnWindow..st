rendering
renderOnWindow: aWindow
	| frameIndex colorBuffer |
	frameIndex := engine newFrame.
	intermediateRenderTarget extent: aWindow screenExtent.
	self renderOnIntermediateTarget: intermediateRenderTarget.
	colorBuffer := intermediateRenderTarget currentColorBuffer.
	intermediateRenderTarget advanceFramebuffer.
	
	self compose: frameIndex colorBuffer: colorBuffer on: aWindow