printing
printOn: aStream
	aStream nextPutAll: 'WMVector3F x: '; print: x;
		nextPutAll: ' y: '; print: y;
		nextPutAll: ' z: '; print: z