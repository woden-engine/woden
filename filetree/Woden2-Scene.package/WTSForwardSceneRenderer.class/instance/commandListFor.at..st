per window state
commandListFor: window at: frameIndex
	| state |
	state := window propertyAt: #forwardSceneRendererState.
	
	state framebufferCount = engine frameBufferingCount ifTrue: [
		^ state commandLists at: frameIndex
	] ifFalse: [
		^ (state commandLists at: window backBufferIndex) at: frameIndex
	]