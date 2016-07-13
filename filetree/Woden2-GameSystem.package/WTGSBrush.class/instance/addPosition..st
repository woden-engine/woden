as yet unclassified
addPosition: aPosition
	| index |
	index := positions size.
	positions add: aPosition.
	^ index