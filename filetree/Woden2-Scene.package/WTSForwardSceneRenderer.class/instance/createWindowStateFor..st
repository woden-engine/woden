per window state
createWindowStateFor: window
	| state |
	window propertyAt: #forwardSceneRendererState ifPresent: [ ^ self ]. 
	state := WTSForwardSceneRendererWindowData new.
	window propertyAt: #forwardSceneRendererState put: state. 
	
	state framebufferCount: window frameBufferCount.
	
	state framebufferCount = engine frameBufferingCount ifTrue: [ 
		state commandAllocators: (engine frameBufferingCollect: [:frameId | engine createGraphicsDirectCommandListAllocator]).
		state commandLists: (state commandAllocators collect: #createListNow).
		state stateCaches: (engine frameBufferingCollect: [:frameId | nil asValueHolder])
	] ifFalse: [ 
		state commandAllocators: ((1 to: state framebufferCount) collect: [:wi | engine frameBufferingCollect: [:frameId | engine createGraphicsDirectCommandListAllocator] ]).
		state commandLists: (state commandAllocators collect: [:array | array collect: #createListNow]).
		state stateCaches: ((1 to: state framebufferCount) collect: [:wi | engine frameBufferingCollect: [:frameId | nil asValueHolder]])
	]