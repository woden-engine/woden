printing
printOn: aStream
	aStream nextPutAll: 'WTCanvasVertex2D new position: '; print: position; nextPutAll: ' texcoord '; print: texcoord; nextPutAll: ' color: '; print: color.