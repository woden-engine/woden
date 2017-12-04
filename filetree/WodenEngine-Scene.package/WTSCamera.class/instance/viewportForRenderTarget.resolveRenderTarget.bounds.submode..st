viewport construction
viewportForRenderTarget: aRenderTarget resolveRenderTarget: aResolveRenderTarget bounds: bounds submode: submode
	^ WTSViewport new
		camera: self;
		renderTarget: aRenderTarget;
		resolveRenderTarget: aResolveRenderTarget;
		bounds: (0@0 extent: aRenderTarget extent);
		submode: submode