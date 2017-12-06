instance creation
open

	| v |
	v := RTView new.
	v @ RTDraggableView.
	self openOn: v.
	v open.
	