actions
addLightEntity: aPosition
	| entity |
	Transcript show: 'addLightEntity:'; cr.
	entity := WTGSEntity new ensureSpatialDescription; ensureSceneNodeOfType: WTSLightSource.
	map addEntity: entity.