actions
doHighlightElement: anElement
	| v |
	self recordElement: anElement.	"not sure if we need to return something"
	v := anElement trachelShape color: (self highlightColorFor: anElement).
	anElement signalUpdate.
	^ v