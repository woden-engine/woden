selection
elementInPositionWithRayPicking: aPoint
	| nx ny |
	nx := aPoint x / window screenWidth.
	ny := 1.0 - (aPoint y / window screenHeight).
	^ view rayPickNormalizedPosition: nx @ ny.
