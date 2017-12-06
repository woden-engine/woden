tests
testBaseShape
	| baseShape |
	baseShape := view baseShapeNodeFor: #dummyShape.
	self assert: baseShape == nil