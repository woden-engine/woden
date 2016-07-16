rendering
renderFrame: frameIndex camera: camera on: aWindow submode: submode
	| viewport |
	viewport := WTSViewport new
		camera: camera;
		bounds: (0@0 extent: aWindow screenExtent);
		submode: submode.
	^ self renderFrame: frameIndex viewports: { viewport } on: aWindow currentFramebuffer