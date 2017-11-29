tests
testBaseShapePutting
	| baseShape node |
	node := WDInstancedGroupNode new.
	baseShape := view baseShapeNodeNamed: #dummyShape ifAbsentPut: [ node ].
	self assert: baseShape equals: node