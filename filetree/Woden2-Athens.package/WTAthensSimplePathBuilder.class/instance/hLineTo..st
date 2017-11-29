builder commands
hLineTo: x
	absolute
		ifTrue: [ self lineToX: x Y: lastSegment endPoint y ]
		ifFalse: [ self lineToX: x Y: 0 ]