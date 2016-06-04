as yet unclassified
addBoundingBox: boundingBox
	self
		beginWithNewBaseVertex;
		addVertex: boundingBox bottomLeft;
		addVertex: boundingBox bottomRight;
		addVertex: boundingBox topRight;
		addVertex: boundingBox topLeft;
		addIndex: 0;
		addIndex: 1;
		addIndex: 2;
		addIndex: 2;
		addIndex: 3;
		addIndex: 0.