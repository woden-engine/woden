tests
testTranslate
	| brush vector |
	vector := (WMVector3D x: 3.0 y: 0.0 z: 0.0 ).
	brush := WTGSBrush unitCube translateBy: vector.
	self assert: (brush boundingBox closeTo: (WMBox3DD unitCube translatedBy: vector))