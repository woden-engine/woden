as yet unclassified
sendCommandsTo: aPathBuilder
	aPathBuilder absolute.
	firstSegment ifNotNil: [ firstSegment sendCommandsTo: aPathBuilder ].