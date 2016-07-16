coordinate systems
normalizedPosition: aPosition
	| x y |
	x := aPosition x / self width.
	y := 1.0 - (aPosition y / self height).
	^ x asFloat @ y