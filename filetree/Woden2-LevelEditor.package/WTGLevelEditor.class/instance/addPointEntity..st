actions
addPointEntity: aPosition
	| entity |
	Transcript show: 'addPointEntity:'; cr.
	entity := WTGSEntity new ensureSpatialDescription.
	map addEntity: entity.