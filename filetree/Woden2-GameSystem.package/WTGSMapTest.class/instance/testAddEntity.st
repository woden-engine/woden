tests
testAddEntity
	| map entity |
	map := WTGSMap new.
	entity := WTGSEntity new.
	map addEntity: entity.
	self assert: map numberOfEntities equals: 1.
	self assert: map entities first equals: entity.
	self assert: entity map equals: map.