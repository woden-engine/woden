as yet unclassified
validBuffer
	buffer ifNil: [ buffer := self createBuffer: capacity ].
	^ buffer