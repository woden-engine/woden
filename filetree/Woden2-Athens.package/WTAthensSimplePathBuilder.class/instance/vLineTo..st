builder commands
vLineTo: y
	absolute
		ifTrue: [ self lineToX: lastSegment endPoint x Y: y ]
		ifFalse: [ self lineToX: 0 Y: y ]