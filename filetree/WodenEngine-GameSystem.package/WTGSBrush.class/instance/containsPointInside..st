intersection
containsPointInside: aPoint
	faces do: [ :face | (face plane isBehind: aPoint) ifFalse: [ ^false ] ].
	^ true