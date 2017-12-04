tests
testNew
	| entity |
	entity := WTGSEntity new.
	self assert: entity numberOfComponents equals: 0.