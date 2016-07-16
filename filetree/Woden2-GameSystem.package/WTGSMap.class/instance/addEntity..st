as yet unclassified
addEntity: anEntity
	entities add: anEntity.
	anEntity addedToMap: self.
	scene ifNotNil: [ anEntity addedToScene: self ]