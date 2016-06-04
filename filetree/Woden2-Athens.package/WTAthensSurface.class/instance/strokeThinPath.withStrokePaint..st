as yet unclassified
strokeThinPath: aPath withStrokePaint: aStrokePaint.
	currentColor := aStrokePaint fillPaint asColor asWMVector4F.
	self
		beginShape: AGPU_LINES pipeline: (convexColorLinePipeline at: blendMode);
		beginWithNewBaseVertex.
	strokePathTessellator reset.
	aPath sendCommandsTo: strokePathTessellator
