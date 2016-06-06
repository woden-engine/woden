as yet unclassified
renderLodenFont: face scaleFactor: scaleFactor character: character position: position
	| glyphIndex glyph texcoordScale box boxExtent translation extraY |
	glyphIndex := (face characterMap at: character ifAbsent: [ 0 ]) + 1.
	glyph := face glyphs at: glyphIndex.
	texcoordScale := face texcoordScaleFactor.
	box := glyph box.
	boxExtent := box max - box min.
	translation := position + (WMVector2F x: 0.0 y: glyph computePreciseAscent asFloat negated * scaleFactor).
	boxExtent := boxExtent * scaleFactor.
	self
		beginWithNewBaseVertex;
		addTransformingVertex: translation texcoord: box bottomLeft * texcoordScale;
		addTransformingVertex: (WMVector2F x: boxExtent x y: 0.0) + translation texcoord: box bottomRight * texcoordScale;
		addTransformingVertex: boxExtent + translation texcoord: box topRight * texcoordScale;
		addTransformingVertex: (WMVector2F x: 0.0 y: boxExtent y) + translation texcoord: box topLeft * texcoordScale;
		addIndex: 0;
		addIndex: 1;
		addIndex: 2;
		addIndex: 2;
		addIndex: 3;
		addIndex: 0.
	^ position + (WMVector2F x: glyph advance x * scaleFactor)