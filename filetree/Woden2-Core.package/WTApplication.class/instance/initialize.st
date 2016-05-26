initialization
initialize
	super initialize.
	engine ifNil: [ engine := WTEngine new. ].
	self initializeApplication.
	self initializeForNewSession.