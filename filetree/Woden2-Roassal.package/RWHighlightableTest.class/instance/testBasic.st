tests
testBasic
	box := (RWCube new color: Color green) element.
	self assert: (box trachelShape color) = Color green.

	box @ RWHighlightable.
	self assert: (box trachelShape color) = Color green.
	
	box announce: RWMouseEnter.
	self assert: box trachelShape color = RTHighlightable highlightedColor.
	
	box announce: RWMouseLeave.
	self assert: (box trachelShape color) = Color green.
	
