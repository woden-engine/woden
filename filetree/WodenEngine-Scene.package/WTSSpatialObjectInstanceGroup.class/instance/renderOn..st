rendering
renderOn: stateTracker
	renderable ifNil: [ ^ self ].
	
	stateTracker
		useShaderResources: self currentObjectStateBinding.
		
	renderable renderOn: stateTracker instanceCount: children size baseInstance: 0 baseVertex: 0