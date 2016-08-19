printing
printOn: aStream
	aStream nextPutAll: 'WMMatrix2D newFrom: #('; cr;
		tab; print: m11; space; print: m12; cr;
		tab; print: m21; space; print: m22; cr;
		nextPut: $)