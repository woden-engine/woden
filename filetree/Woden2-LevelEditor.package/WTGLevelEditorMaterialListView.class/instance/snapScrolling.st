event handling
snapScrolling
	verticalScroll := verticalScroll min: 0 max: (self computeCellHeight * (self computeGridSize y - 1) max: 0) negated