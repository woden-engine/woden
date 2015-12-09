initialization
initializeForNewSession
	self createDevice.
	self createPipelineStateManager.
	
	session := Smalltalk session.