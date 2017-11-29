as yet unclassified
testAddRootWithChildren
	| scene root child |
	scene := WTSScene new.
	root := WTSNode new.
	child := WTSNode new.
	root addChild: child.
	
	self assert: scene numberOfRoots equals: 0.
	scene add: root.
	self assert: scene numberOfRoots equals: 1.
	self assert: root scene equals: scene.
	self assert: child scene equals: scene.