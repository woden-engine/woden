as yet unclassified
edges
	"
	self new edges
	"

	| v el1 el2 |
	v := RWView new.

	el1 := RWCube element.
	el2 := RWCube element.

	v addAll: { el1 . el2 }.

	RWXZGridLayout on: v elements.

	v add: (RWLine green edgeFrom: el1 to: el2 ).

	v addInteraction: RWMouseKeyControl.
	^ v 