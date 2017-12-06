base shapes
baseShapeNodeFor: baseShapeDescriptor
	^ baseShapes at: baseShapeDescriptor ifAbsent: [ nil ]