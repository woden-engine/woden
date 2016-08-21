actions
addPlayerSpawnPoint: aPosition
	| entity |
	entity := WTGSEntity new.
	entity
		addComponent: WTGSSpatialDescription new;
		addComponent: (WTGSBehaviorClass new behaviorClassName: WTGSPlayerSpawnPointBehavior name).
	entity spatialDescription
		translation: aPosition;
		localBoundingBox: (WMBox3DD halfExtent: WTGSPlayerBehavior halfExtent).
	map addEntity: entity.