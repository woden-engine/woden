initialization
createRenderTarget
	renderTarget := WDCRenderTarget for: engine extent: self drawingSurfaceExtent.
	renderTarget
		hasDepth: self hasDepth;
		hasStencil: self hasStencil;
		sampleCount: self sampleCount.
		
	self sampleCount > 1 ifTrue: [ 
		renderTarget createFramebuffers.
		
		resolveRenderTarget := WDCRenderTarget for: engine extent: self drawingSurfaceExtent.
		resolveRenderTarget
			hasDepth: false;
			hasStencil: false;
			sampleCount: 1;
			gpuOnly: false;
			createFramebuffers.
	] ifFalse: [
		renderTarget gpuOnly: false; createFramebuffers.
		resolveRenderTarget := renderTarget
	].