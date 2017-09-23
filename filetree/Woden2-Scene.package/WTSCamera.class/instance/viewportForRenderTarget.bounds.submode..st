as yet unclassified
viewportForRenderTarget: aRenderTarget bounds: bounds submode: submode
	^ WTSViewport new
		camera: self;
		bounds: bounds;
		submode: submode.