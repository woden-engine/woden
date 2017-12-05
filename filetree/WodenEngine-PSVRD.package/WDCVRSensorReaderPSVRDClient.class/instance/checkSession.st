session management
checkSession
	(connection isNil or: [session ~~ Smalltalk session]) ifTrue: [
		self startConnection
	]