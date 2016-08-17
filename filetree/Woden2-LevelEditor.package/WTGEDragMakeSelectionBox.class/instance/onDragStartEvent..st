as yet unclassified
onDragStartEvent: event
	| depth selectionBox |
	depth := view depthAtCameraDistance: 3.0.
	startPoint := (view windowGlobalToWorld: event position depth: depth).
	
	xdirection := view xDragDirection.
	ydirection := view yDragDirection.
	zdirection := view zDragDirection.
	selectionBox := view editor selectionBox.
	selectionBox isEmpty ifTrue: [
		nearPosition := -1.0.
		farPosition := 1.0.
	] ifFalse: [
		nearPosition := zdirection dot: (selectionBox box support: zdirection negated).
		farPosition := zdirection dot: (selectionBox box support: zdirection).
	].
	
	view editor selection: WTGLevelEditorSelectionBox empty.