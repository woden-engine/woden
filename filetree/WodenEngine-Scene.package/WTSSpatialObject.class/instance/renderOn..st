rendering
renderOn: stateTracker
	renderable ifNil: [ ^ self ].
	
	stateTracker
		useShaderResources: self currentObjectStateBinding.
		
	renderable renderOn: stateTracker instanceCount: 1 baseInstance: 0 baseVertex: 0