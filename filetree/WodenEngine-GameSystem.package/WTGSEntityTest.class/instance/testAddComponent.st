tests
testAddComponent
	| entity component |
	entity := WTGSEntity new.
	component := WTGSComponent new.
	entity addComponent: component.
	self assert: entity numberOfComponents equals: 1.
	self assert: component entity equals: entity.
	