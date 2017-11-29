initialization
checkSession
	session ~~ Smalltalk session ifTrue: [
		self initializeForNewSession
	]