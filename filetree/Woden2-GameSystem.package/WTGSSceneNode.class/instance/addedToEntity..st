adding
addedToEntity: anEntity
	super addedToEntity: anEntity.
	self addedToScene: anEntity scene.
	node ifNotNil: [
		anEntity spatialDescription ifNotNil: [ :desc | node transform: desc transform ]
	].

	self updatePointEntityState.