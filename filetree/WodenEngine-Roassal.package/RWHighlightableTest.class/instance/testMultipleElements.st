tests
testMultipleElements
	| box1 box2 |
	box1 := (RWCube new color: Color green) element.
	box2 := (RWCube new color: Color red) element.
	
	box1 @ (RWHighlightable highlightElements: [ :e | Array with: box2 ]).
	box1 announce: RWMouseEnter.

	"The Roassal shape remains the same"
	self assert: (box1 shape colorFor: box1) = Color green.
	self assert: box1 trachelShape color = Color green.
	self assert: box2 trachelShape color = RWHighlightable highlightedColor.
	
	box1 announce: RWMouseLeave.
	self assert: box1 trachelShape color = Color green.
	self assert: box2 trachelShape color = Color red