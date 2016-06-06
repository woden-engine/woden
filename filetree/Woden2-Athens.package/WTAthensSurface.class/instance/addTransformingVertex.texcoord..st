as yet unclassified
addTransformingVertex: position texcoord: texcoord
	vertices add: (WTCanvasVertex2D new
		position: (pathTransform transformPosition2: position);
		texcoord: texcoord;
		color: currentColor)