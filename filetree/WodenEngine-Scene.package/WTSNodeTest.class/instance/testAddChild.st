tests
testAddChild
	| node child |
	node := WTSNode new.
	child := WTSNode new.
	node addChild: child.
	self assert: node numberOfChildren equals: 1.