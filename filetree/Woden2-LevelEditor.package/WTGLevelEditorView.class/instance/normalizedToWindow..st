coordinate systems
normalizedToWindow: aVector3
	| myExtent x y |
	myExtent := self innerBounds extent.
	
	x := myExtent x * aVector3 x.
	y := myExtent y * (1.0 - aVector3 y).
	^ x @ y