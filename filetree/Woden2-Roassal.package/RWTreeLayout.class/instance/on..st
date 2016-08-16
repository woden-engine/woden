public
on: allElements
	self on: (allElements select: [ :e | e isEdge not] )
		edges: (allElements select: [ :e | e isEdge] )