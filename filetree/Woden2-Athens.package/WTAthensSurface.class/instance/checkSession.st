session management
checkSession
	session ~~ Smalltalk session ifTrue: [
		self initializeForNewSession
	]