initialization
initializeForNewSession
	self initializePerSessionResources.
	self initializePerFrameResources.
	
	session := Smalltalk session.