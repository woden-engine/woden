testing
containsPoint: aPoint
	faces do: [ :face | (face plane isInFront: aPoint) ifTrue: [ ^false ] ].
	^ true