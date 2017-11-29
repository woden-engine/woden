path commands
absoluteLineTo: aPoint
	closed ifTrue: [
		backend
			subpathStarted;
			addVertex: lastPoint.
		closed := false.
	].

	backend
		addVertex: aPoint.
	lastPoint := aPoint.