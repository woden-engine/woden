rendering dispatch
fillRectangle: aRectangle withTexture: aTexture
	| boundingBox |
	currentColor := Color white asWMVector4F.
	boundingBox := aRectangle asWMBox2DF.
	self
		beginShape: AGPU_TRIANGLES pipeline: (convexTexturedTrianglePipeline at: blendMode) texture: aTexture binding font: nil;
		beginWithNewBaseVertex;
		addTransformingVertex: boundingBox bottomLeft texcoord: (WMVector2F x: 0.0 y: 0.0);
		addTransformingVertex: boundingBox bottomRight texcoord: (WMVector2F x: 1.0 y: 0.0);
		addTransformingVertex: boundingBox topRight texcoord: (WMVector2F x: 1.0 y: 1.0);
		addTransformingVertex: boundingBox topLeft texcoord: (WMVector2F x: 0.0 y: 1.0);
		addIndex: 0;
		addIndex: 1;
		addIndex: 2;
		addIndex: 2;
		addIndex: 3;
		addIndex: 0.