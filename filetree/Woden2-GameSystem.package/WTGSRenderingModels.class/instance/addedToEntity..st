adding
addedToEntity: anEntity
	super addedToEntity: anEntity.
	anEntity ensureSpatialObject.
	self addedToScene: anEntity scene.