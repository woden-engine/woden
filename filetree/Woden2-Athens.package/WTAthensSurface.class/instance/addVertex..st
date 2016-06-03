public
addVertex: position
	vertices add: (WTCanvasVertex2D new
		position: position;
		color: currentColor)