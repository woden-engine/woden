initialization
initialize
	super initialize.
	engine ifNil: [ engine := WDCEngine default. ].
	
	views := OrderedCollection new.
	started := false.
	self initializeModel.
	self initializeForNewSession.