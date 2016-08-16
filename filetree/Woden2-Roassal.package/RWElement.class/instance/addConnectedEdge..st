adding
addConnectedEdge: anEdge
	[  anEdge class == RWEdge ] assert.
	self connectedEdges add: anEdge