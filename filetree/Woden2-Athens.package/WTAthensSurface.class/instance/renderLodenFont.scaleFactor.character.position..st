rendering dispatch
renderLodenFont: face scaleFactor: scaleFactor character: character position: position
	| glyphIndex glyph texcoordScale margin sourceRect destRect |
	glyphIndex := (face characterMap at: character ifAbsent: [ 0 ]) + 1.
	glyph := face glyphs at: glyphIndex.
	texcoordScale := face texcoordScaleFactor.
	margin := (0.0 max: face cellMargin - 1) asFloat.
	sourceRect := glyph computeSourceRectangleWithTexcoordScale: texcoordScale margin: margin.
	destRect := glyph computeDestinationRectangleWithScale: scaleFactor margin: margin position: position.
	
	self
		beginWithNewBaseVertex;
		addTransformingVertex: destRect bottomLeft texcoord: sourceRect bottomLeft;
		addTransformingVertex: destRect bottomRight texcoord: sourceRect bottomRight;
		addTransformingVertex: destRect topRight texcoord: sourceRect topRight;
		addTransformingVertex: destRect topLeft texcoord: sourceRect topLeft;
		addIndex: 0;
		addIndex: 1;
		addIndex: 2;
		addIndex: 2;
		addIndex: 3;
		addIndex: 0.

	^ position + (WMVector2F x: glyph advance x * scaleFactor)