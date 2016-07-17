as yet unclassified
updateSelectionBox
	| leftPosition rightPosition bottomPosition topPosition near far min max box |
	leftPosition := self roundToGrid: (xdirection dot: startPoint).
	rightPosition := self roundToGrid: (xdirection dot: endPoint).
	bottomPosition := self roundToGrid: (ydirection dot: startPoint).
	topPosition := self roundToGrid: (ydirection dot: endPoint).
	near := self roundToGrid: nearPosition.
	far := self roundToGrid: farPosition.
	
	min := (xdirection * leftPosition) + (ydirection * bottomPosition) + (zdirection * near).
	max := (xdirection * rightPosition) + (ydirection * topPosition) + (zdirection * far).
	box := WMBox3DD empty
		insertPoint: min;
		insertPoint: max;
		yourself.
	self editor selectionBox: box.