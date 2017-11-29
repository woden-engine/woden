as yet unclassified
testAddRoot
	| scene root |
	scene := WTSScene new.
	root := WTSNode new.
	self assert: scene numberOfRoots equals: 0.
	scene add: root.
	self assert: scene numberOfRoots equals: 1.
	self assert: root scene equals: scene.