adding
addVertex: aPoint
	surface addVertex: aPoint asWMVector2F.
	pathVertexCount := pathVertexCount + 1.
	subpathVertexCount := subpathVertexCount + 1.
	subpathVertexCount >= 2 ifTrue: [
		surface
			addIndex: subpathFirstVertex + subpathVertexCount - 2;
			addIndex: subpathFirstVertex + subpathVertexCount - 1
	]