session management
checkSession
	session ~~ Smalltalk session ifTrue: [
		engine checkSession.
		self buildHandle.
		session := Smalltalk session.
	]