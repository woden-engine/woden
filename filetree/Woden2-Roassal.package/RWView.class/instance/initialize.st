initialization
initialize
	super initialize.
	engine ifNil: [ engine := WTEngine new. ].
	signalUpdateCallback := [  ]. "Nothing per default"
	currentTime := 0.0.
	elements := OrderedCollection new.
	internalElements := OrderedCollection new.
	eventHandler := Announcer new.
	baseShapes := IdentityDictionary new.
	rigidBodies := OrderedCollection new.
	isStereo := false.
	fullscreen := false.
	self initializeScene.