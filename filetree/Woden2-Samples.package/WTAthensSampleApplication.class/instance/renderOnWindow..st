rendering
renderOnWindow: aWindow
	| frameIndex surface framebuffer extent |
	frameIndex := engine newFrame.
	framebuffer := aWindow currentFramebuffer.
	extent := aWindow screenExtent.
	surface := athensSurfaces at: frameIndex.
	surface framebuffer: framebuffer extent: extent.
	self renderOnAthens: surface.