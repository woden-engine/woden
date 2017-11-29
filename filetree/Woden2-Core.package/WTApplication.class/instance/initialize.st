initialization
initialize
	super initialize.
	fullscreen := false.
	engine ifNil: [ engine := WTEngine new. ].
	self initializeApplication.
	self initializeForNewSession.