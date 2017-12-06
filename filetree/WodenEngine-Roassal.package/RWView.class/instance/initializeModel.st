initialization
initializeModel
	elements := OrderedCollection new.
	internalElements := OrderedCollection new.
	eventHandler := Announcer new.
	baseShapes := Dictionary new.
	rigidBodies := OrderedCollection new.
	isStereo := false.
	fullscreen := false.
	self initializeScene.