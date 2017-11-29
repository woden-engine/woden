as yet unclassified
addTransformingVertex: position
	vertices add: (WTCanvasVertex2D new
		position: (pathTransform transformPosition2: position);
		texcoord: currentTexcoord;
		color: currentColor)