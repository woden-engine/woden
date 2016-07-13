as yet unclassified
addedToEntity: anEntity
	entity ifNotNil: [ entity invalidateModels ].
	super addedToEntity: anEntity.
	entity ifNotNil: [ entity invalidateModels ].