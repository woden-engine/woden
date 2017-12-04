initialization
checkSession
	engine checkSession.
	session ~~ Smalltalk session ifTrue: [
		self initializeForNewSession.
	].