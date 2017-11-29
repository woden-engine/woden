space-calculation
areasOverlaping: oneRect outsideOf: anotherRect 
	"Answer an Array of maximized Rectangles comprising (overlaped by each other) the parts of the receiver not 
	intersecting aRectangle."
	"Make sure the intersection is non-empty"
	| areas |
	(oneRect intersects: anotherRect) ifFalse: [ ^ Array with: oneRect ].
	areas := OrderedCollection new.
	anotherRect origin y > oneRect origin y 
		ifTrue: 
			[ areas addLast: (oneRect origin corner: oneRect corner x @ anotherRect origin y) ].
	anotherRect corner y < oneRect corner y 
		ifTrue: 
			[ areas addLast: (oneRect origin x @ anotherRect corner y corner: oneRect corner) ].
	anotherRect origin x > oneRect origin x 
		ifTrue: 
			[ areas addLast: (oneRect origin corner: anotherRect origin x @ oneRect corner y) ].
	anotherRect corner x < oneRect corner x 
		ifTrue: 
			[ areas addLast: (anotherRect corner x @ oneRect origin y corner: oneRect corner) ].
	^ areas