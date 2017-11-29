adding
addedToEntity: anEntity
	super addedToEntity: anEntity.
	anEntity ensureSceneNodeOfType: WTSLightSource.
	self updateSceneNode