adding
removedFromEntity: anEntity
	entity ifNotNil: [ entity invalidateModels ].
	super removedFromEntity: anEntity.
