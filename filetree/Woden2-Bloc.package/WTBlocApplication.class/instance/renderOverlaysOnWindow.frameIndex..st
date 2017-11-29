rendering
renderOverlaysOnWindow: aWindow frameIndex: frameIndex
	| surface framebuffer extent |
	framebuffer := aWindow currentFramebuffer.
	extent := aWindow screenExtent.
	surface := athensSurfaces at: frameIndex.
	surface framebuffer: framebuffer extent: extent.
	(mainBlocSpace isNotNil and: [ mainBlocSpace extent ~= extent ]) ifTrue: [
		mainBlocSpace extent: extent
	].
	self renderOnAthens: surface.