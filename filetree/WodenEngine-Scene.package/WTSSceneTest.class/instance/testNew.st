as yet unclassified
testNew
	| scene |
	scene := WTSScene new.
	self assert: scene numberOfRoots equals: 0.
	self assert: scene backgroundColor isColor.