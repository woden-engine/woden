adding
addEntity: anEntity
	entities add: anEntity.
	anEntity addedToMap: self.
	scene ifNotNil: [ anEntity addedToScene: scene ]