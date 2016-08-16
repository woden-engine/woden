base shapes
baseShapeNodeNamed: baseShapeName ifAbsentPut: aBlock
	|node |
	^ baseShapes at: baseShapeName ifAbsentPut: [
		node := aBlock value.
		scene add: node.
		node
	]