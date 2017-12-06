tests
testBaseShape
	| baseShape |
	baseShape := view baseShapeNodeNamed: #dummyShape.
	self assert: baseShape == nil