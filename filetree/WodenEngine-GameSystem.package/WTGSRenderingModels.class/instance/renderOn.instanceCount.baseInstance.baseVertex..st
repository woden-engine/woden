rendering
renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex 
	| model |
	
	model := self modelForSubMode: stateTracker submode.
	model renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex 