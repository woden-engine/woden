as yet unclassified
updateSelectionBox
	| leftPosition rightPosition bottomPosition topPosition near far min max box |
	leftPosition := xdirection dot: startPoint.
	rightPosition := xdirection dot: endPoint.
	bottomPosition := ydirection dot: startPoint.
	topPosition := ydirection dot: endPoint.
	near := nearPosition.
	far := farPosition.
	
	min := (xdirection * leftPosition) + (ydirection * bottomPosition) + (zdirection * near).
	max := (xdirection * rightPosition) + (ydirection * topPosition) + (zdirection * far).
	box := WMBox3DD empty
		insertPoint: min;
		insertPoint: max;
		yourself.
	self editor selectionBox box: (view snapBox: box).