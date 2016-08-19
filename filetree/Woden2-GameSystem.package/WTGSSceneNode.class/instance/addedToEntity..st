adding
addedToEntity: anEntity
	super addedToEntity: anEntity.
	self addedToScene: anEntity scene.
	self updatePointEntityState.