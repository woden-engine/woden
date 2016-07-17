per window state
frameStateCacheFor: window at: frameIndex
	| state |
	state := window propertyAt: #forwardSceneRendererState.
	
	state framebufferCount = engine frameBufferingCount ifTrue: [
		^ state stateCaches at: frameIndex
	] ifFalse: [
		^ (state stateCaches at: window backBufferIndex) at: frameIndex
	]