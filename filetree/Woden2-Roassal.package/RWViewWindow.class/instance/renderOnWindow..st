drawing
renderOnWindow: aWindow
	| frameIndex framebuffer extent surface |
	frameIndex := engine newFrame.
	framebuffer := aWindow currentFramebuffer.
	extent := aWindow screenExtent.
	surface := athensSurfaces at: frameIndex.
	surface framebuffer: framebuffer extent: extent.

	view ifNil: [ ^ self renderNoViewOnWindow: aWindow onAthensSurface: surface].
	
	view render3DOnWindow: aWindow extraRenderTime: accumulatedUpdateTime.
	
	surface drawDuring: [:canvas |
		view render2DOnSurface: surface canvas: aWindow.
		self renderFramesPerSecondOn: surface canvas: canvas
	].
