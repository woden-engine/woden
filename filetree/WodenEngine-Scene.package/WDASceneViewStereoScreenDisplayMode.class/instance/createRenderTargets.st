multi eye rendering
createRenderTargets
	| extent sampleCount hasDepth hasStencil |
	extent := view window validResolveRenderTarget extent.
	sampleCount := view sampleCount.
	hasDepth := view hasDepth.
	hasStencil := view hasStencil.
	
	leftRenderTarget := WDCRenderTarget for: engine extent: extent.
	leftRenderTarget
		hasDepth: hasDepth;
		hasStencil: hasStencil;
		sampleCount: sampleCount;
		createFramebuffers.

	rightRenderTarget := WDCRenderTarget for: engine extent: extent.
	rightRenderTarget
		hasDepth: hasDepth;
		hasStencil: hasStencil;
		sampleCount: sampleCount;
		createFramebuffers.
		
	sampleCount > 1 ifTrue: [ 
		leftResolveRenderTarget := WDCRenderTarget for: engine extent: extent.
		leftResolveRenderTarget
			hasDepth: hasDepth;
			hasStencil: hasStencil;
			sampleCount: 1;
			createFramebuffers.

		rightResolveRenderTarget := WDCRenderTarget for: engine extent: extent.
		rightResolveRenderTarget
			hasDepth: hasDepth;
			hasStencil: hasStencil;
			sampleCount: 1;
			createFramebuffers.
	] ifFalse: [
		leftResolveRenderTarget := leftRenderTarget.
		rightResolveRenderTarget := rightRenderTarget.
	].
