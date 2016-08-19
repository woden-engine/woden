printing
printOn: aStream
	aStream nextPutAll: 'WMMatrix4F newFrom: #('; cr;
		tab; print: m11; space; print: m12; space; print: m13; space; print: m14; cr;
		tab; print: m21; space; print: m22; space; print: m23; space; print: m24; cr;
		tab; print: m31; space; print: m32; space; print: m33; space; print: m34; cr;
		tab; print: m41; space; print: m42; space; print: m43; space; print: m44; cr;
		nextPut: $)