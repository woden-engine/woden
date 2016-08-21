snapping
roundToGrid: value
	| quantum |
	quantum := self secondaryGridSize.
	^ ((value / quantum) + 0.5) floor * quantum