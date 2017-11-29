as yet unclassified
addPendingUpdate: aNode
	updatedPerFrame ifFalse: [ pendingUpdates add: aNode ]