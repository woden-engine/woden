instance creation
createRenderTarget
	self sampleCount > 1 ifTrue: [
		renderTarget := WDCRenderTarget for: engine extent: self drawingSurfaceExtent.
		renderTarget
			hasDepth: self hasDepth;
			hasStencil: self hasStencil;
			sampleCount: self sampleCount;
			createFramebuffers.

		resolveRenderTarget := WDCSwapChainRenderTarget for: engine extent: self drawingSurfaceExtent windowHandle: window platformSpecificHandle.
		resolveRenderTarget
			hasDepth: false;
			hasStencil: false;
			sampleCount: 1;
			createFramebuffers.
	] ifFalse: [
		resolveRenderTarget := WDCSwapChainRenderTarget for: engine extent: self drawingSurfaceExtent windowHandle: window platformSpecificHandle.
		resolveRenderTarget
			hasDepth: self hasDepth;
			hasStencil: self hasStencil;
			sampleCount: 1;
			createFramebuffers.

		renderTarget := resolveRenderTarget
	].