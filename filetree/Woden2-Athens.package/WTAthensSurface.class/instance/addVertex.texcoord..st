as yet unclassified
addVertex: position texcoord: texcoord
	vertices add: (WTCanvasVertex2D new
		position: position;
		texcoord: texcoord;
		color: currentColor)