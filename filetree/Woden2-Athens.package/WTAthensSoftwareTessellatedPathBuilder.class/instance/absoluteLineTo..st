path commands
absoluteLineTo: aPoint
	closed ifTrue: [
		baseIndex := backend numberOfVertices.
		backend
			subpathStarted;
			addVertex: lastPoint.
		closed := false.
	].

	backend
		addVertex: aPoint.
	lastPoint := aPoint.