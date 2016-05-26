initialization
initializeForNewSession
	engine checkSession.
	self createFramebuffer.

	session := Smalltalk session.
	