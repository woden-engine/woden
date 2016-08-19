printing
printOn: aStream
	aStream nextPutAll: 'WMVector4US x: '; print: x;
		nextPutAll: ' y: '; print: y;
		nextPutAll: ' z: '; print: z;
		nextPutAll: ' w: '; print: w