printing
printOn: aStream
	aStream nextPutAll: 'WTSkinnedGenericVertexF new position: ('; print: position; nextPutAll: ') texcoord: ('; print: texcoord; nextPutAll: ') normal: ('; print: normal; nextPutAll: ') color: ('; print: color;
	nextPutAll: ') tangent4: ('; print: tangent4; nextPutAll: ')'