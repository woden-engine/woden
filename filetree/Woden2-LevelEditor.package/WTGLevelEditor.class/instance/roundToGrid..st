snapping
roundToGrid: value
	| quantum |
	quantum := self secondaryGridSize.
	^ (value / quantum) floor * quantum