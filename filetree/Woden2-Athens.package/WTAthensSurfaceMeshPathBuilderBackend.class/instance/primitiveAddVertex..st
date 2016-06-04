adding
primitiveAddVertex: aPoint
	surface addVertex: aPoint asWMVector2F.
	pathVertexCount := pathVertexCount + 1.