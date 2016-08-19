printing
printOn: aStream
	aStream nextPutAll: 'WMVector3D x: '; print: x;
		nextPutAll: ' y: '; print: y;
		nextPutAll: ' z: '; print: z