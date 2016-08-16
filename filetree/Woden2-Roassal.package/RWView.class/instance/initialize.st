initialization
initialize
	super initialize.
	engine ifNil: [ engine := WTEngine new. ].
	signalUpdateCallback := [  ]. "Nothing per default"
	currentTime := 0.0.
	elements := OrderedCollection new.
	eventHandler := Announcer new.
	baseShapes := IdentityDictionary new.
	isStereo := false.
	fullscreen := false.
	self initializeScene.