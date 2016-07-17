per window state
commandAllocatorFor: window at: frameIndex
	| state |
	state := window propertyAt: #forwardSceneRendererState.
	
	state framebufferCount = engine frameBufferingCount ifTrue: [
		^ state commandAllocators at: frameIndex
	] ifFalse: [
		^ (state commandAllocators at: window backBufferIndex) at: frameIndex
	]
	