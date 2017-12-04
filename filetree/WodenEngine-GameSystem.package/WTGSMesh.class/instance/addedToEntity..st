adding
addedToEntity: anEntity
	entity ifNotNil: [ entity invalidateModels ].
	super addedToEntity: anEntity.
	entity
		ensureSpatialObject