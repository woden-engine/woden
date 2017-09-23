as yet unclassified
viewportForRenderTarget: aRenderTarget submode: submode
	^ WTSViewport new
		camera: self;
		bounds: (0@0 extent: aRenderTarget screenExtent);
		submode: submode.