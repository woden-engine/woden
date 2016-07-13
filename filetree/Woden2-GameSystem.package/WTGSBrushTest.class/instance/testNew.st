tests
testNew
	| brush |
	brush := WTGSBrush new.
	self assert: brush numberOfFaces equals: 0.
	self deny: brush isValid 