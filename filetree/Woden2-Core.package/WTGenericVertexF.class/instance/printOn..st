printing
printOn: aStream
	aStream nextPutAll: 'WTGenericVertexF new position: '; print: position; nextPutAll: ' texcoord: '; print: texcoord; nextPutAll: ' normal: '; print: normal; nextPutAll: ' color: '; print: color