actions
addPointEntity: aPosition
	| entity |
	entity := WTGSEntity new ensureSpatialDescription.
	entity
		addComponent: WTGSSpatialDescription new.
	entity spatialDescription translation: aPosition.
	map addEntity: entity.