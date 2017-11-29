base shapes
baseShapeNodeNamed: baseShapeName
	^ baseShapes at: baseShapeName ifAbsent: [ nil ]