initialization
initializeForNewSession
	self createDevice.
	self createPipelineStateManager.
	self createFrameFences.
	
	session := Smalltalk session.