wrappers
createFrameBuffer: width height: height renderTargetCount: renderTargetCount hasDepth: hasDepth hasStencil: hasStencil
	| result |
	result := AGPUCBindings createFrameBuffer_device: (self validHandle) width: width height: height renderTargetCount: renderTargetCount hasDepth: hasDepth hasStencil: hasStencil.
	^ AGPUFramebuffer forHandle: result
