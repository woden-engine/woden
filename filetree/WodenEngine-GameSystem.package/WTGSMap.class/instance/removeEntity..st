adding
removeEntity: anEntity
	entities remove: anEntity.
	(touchListeners includes: anEntity) ifTrue: [ touchListeners remove: anEntity ].
	scene ifNotNil: [ anEntity removedFromScene: scene ].
	anEntity removedFromMap: self.