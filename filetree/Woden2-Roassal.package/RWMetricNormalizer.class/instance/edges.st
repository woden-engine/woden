public normalize line width
edges
	edges ifNotNil: [ ^ edges ].
	
	edges := Set new.
	elements do: [ :el | edges addAll: el connectedEdges ]. 
	edges := edges asArray.
	^ edges