rendering
renderOnWindow: aWindow
	| frameIndex framebuffer extent surface |
	frameIndex := engine newFrame.
	self updateCameraProjectionFor: aWindow.
	sceneRenderer
		currentTime: currentTime + accumulatedUpdateTime;
		renderFrame: frameIndex camera: camera on: aWindow.
	
	framebuffer := aWindow currentFramebuffer.
	extent := aWindow screenExtent.
	surface := athensSurfaces at: frameIndex.
	surface framebuffer: framebuffer extent: extent.
	self renderOnAthens: surface.