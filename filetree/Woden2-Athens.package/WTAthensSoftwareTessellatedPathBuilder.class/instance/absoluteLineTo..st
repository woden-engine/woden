path commands
absoluteLineTo: aPoint
	closed ifTrue: [
		baseIndex := backend numberOfVertices.
		subpathStartPoint := lastPoint.
		backend addVertex: lastPoint.
		subpathVertexCount := 1.
		closed := false.
	].

	backend
		addVertex: aPoint.
	subpathVertexCount := subpathVertexCount + 1.
	
	"Add the indices of a triangle fan."
	subpathVertexCount >= 3 ifTrue: [
		backend
			addIndex: baseIndex;
			addIndex: subpathVertexCount + baseIndex - 2;
			addIndex: subpathVertexCount + baseIndex - 1.
	].

	lastPoint := aPoint.