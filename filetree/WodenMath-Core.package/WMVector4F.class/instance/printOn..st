printing
printOn: aStream
	aStream nextPutAll: 'WMVector4F x: '; print: x;
		nextPutAll: ' y: '; print: y;
		nextPutAll: ' z: '; print: z;
		nextPutAll: ' w: '; print: w