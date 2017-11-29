actions
addModel: modelName position: aPosition
	| entity model |
	model := engine resourceCache loadModel: modelName.
	entity := WTGSEntity new.
	entity
		addComponent: WTGSSpatialDescription new;
		addComponent: (WTGSModel new modelName: modelName).
	entity spatialDescription
		localBoundingBox: model boundingBox asWMBox3DD;
		translation: aPosition.
	map addEntity: entity.
	^ entity