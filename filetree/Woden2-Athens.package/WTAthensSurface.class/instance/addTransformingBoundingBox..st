as yet unclassified
addTransformingBoundingBox: boundingBox
	self
		beginWithNewBaseVertex;
		addTransformingVertex: boundingBox bottomLeft;
		addTransformingVertex: boundingBox bottomRight;
		addTransformingVertex: boundingBox topRight;
		addTransformingVertex: boundingBox topLeft;
		addIndex: 0;
		addIndex: 1;
		addIndex: 2;
		addIndex: 2;
		addIndex: 3;
		addIndex: 0.