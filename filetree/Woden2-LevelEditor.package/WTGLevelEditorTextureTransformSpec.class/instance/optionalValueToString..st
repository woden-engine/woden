as yet unclassified
optionalValueToString: anObject
	anObject ifNil: [ ^ '' ].
	^ anObject asString