public
addVertex: position color: color
	vertices add: (WTCanvasVertex2D new
		position: position;
		texcoord: currentTexcoord;
		color: color)