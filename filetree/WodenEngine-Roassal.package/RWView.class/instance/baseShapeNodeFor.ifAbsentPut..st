base shapes
baseShapeNodeFor: baseShapeDescriptor ifAbsentPut: aBlock
	|node |
	^ baseShapes at: baseShapeDescriptor ifAbsentPut: [
		node := aBlock value.
		scene add: node.
		node
	]