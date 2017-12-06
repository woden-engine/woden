selection
elementInPositionWithRayPicking: aPoint
	| nx ny extent |
	extent := window drawingSurfaceExtent.
	nx := aPoint x / extent x asFloat.
	ny := 1.0 - (aPoint y / extent y).
	^ model rayPickNormalizedPosition: nx @ ny.
