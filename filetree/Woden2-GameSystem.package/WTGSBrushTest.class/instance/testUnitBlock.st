tests
testUnitBlock
	| brush |
	brush := WTGSBrush unitCube.
	self assert: brush numberOfFaces equals: 6.
	self assert: brush positions size equals: 8.
	self assert: brush isValid.
	self assert: (brush boundingBox closeTo: WMBox3DD unitCube).