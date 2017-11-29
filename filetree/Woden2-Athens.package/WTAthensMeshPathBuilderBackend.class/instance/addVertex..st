adding
addVertex: aPoint
	self primitiveAddVertex: aPoint.
	boundingBox insertPoint: aPoint.
	subpathVertexCount := subpathVertexCount + 1.
	subpathVertexCount >= 3 ifTrue: [
		self
			addIndex: subpathFirstVertex;
			addIndex: subpathFirstVertex + subpathVertexCount - 2;
			addIndex: subpathFirstVertex + subpathVertexCount - 1
	]