adding
removeEntity: anEntity
	entities remove: anEntity.
	scene ifNotNil: [ anEntity removedFromScene: scene ].
	anEntity removedFromMap: self.