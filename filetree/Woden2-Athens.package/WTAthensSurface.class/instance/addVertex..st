public
addVertex: position
	vertices add: (WTCanvasVertex2D new
		position: position;
		texcoord: currentTexcoord;
		color: currentColor)