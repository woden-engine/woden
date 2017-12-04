tests
testNew
	| map |
	map := WTGSMap new.
	self assert: map numberOfEntities equals: 0.