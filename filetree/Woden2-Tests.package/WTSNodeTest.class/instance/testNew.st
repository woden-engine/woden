tests
testNew
	| node |
	node := WTSNode new.
	self assert: node numberOfChildren equals: 0.
	self assert: node transform isNotNil.
	self assert: node scene isNil.
	self assert: node visible.