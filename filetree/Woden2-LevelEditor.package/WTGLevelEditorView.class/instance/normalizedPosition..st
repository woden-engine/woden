coordinate systems
normalizedPosition: aPosition
	| x y myExtent |
	myExtent := self innerBounds extent.
	
	x := aPosition x / myExtent x.
	y := 1.0 - (aPosition y / myExtent y).
	^ x asFloat @ y