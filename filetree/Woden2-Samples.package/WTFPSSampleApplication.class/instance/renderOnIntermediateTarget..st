rendering
renderOnIntermediateTarget: aRenderTarget
	| frameIndex framebuffer extent surface |
	frameIndex := engine newFrame.
	
	sceneRenderer
		currentTime: currentTime + accumulatedUpdateTime;
		renderFrame: frameIndex camera: camera on: aRenderTarget.
	
	framebuffer := aRenderTarget currentFramebuffer.
	extent := aRenderTarget screenExtent.
	surface := athensSurfaces at: frameIndex.
	surface framebuffer: framebuffer extent: extent.
	self renderOnAthens: surface.