public
on: nodeCollection edges: edgeCollection
	nodes := nodeCollection.
	edges := edgeCollection.
	self buildGraph.
	self computeHeights.
	self distributeHorizontally