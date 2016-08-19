actions
addLightEntity: aPosition
	| entity |
	entity := WTGSEntity new.
	entity
		addComponent: WTGSSpatialDescription new;
		addComponent: WTGSLightSourceComponent new.
	entity spatialDescription translation: aPosition.
	map addEntity: entity.