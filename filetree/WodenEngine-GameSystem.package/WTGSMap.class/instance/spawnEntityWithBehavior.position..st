spawning
spawnEntityWithBehavior: behavior position: aPosition
	| entity |
	entity := WTGSEntity new.
	entity
		addComponent: (WTGSSpatialDescription new translation: aPosition);
		addComponent: behavior.
	self addEntity: entity.
	entity spawn