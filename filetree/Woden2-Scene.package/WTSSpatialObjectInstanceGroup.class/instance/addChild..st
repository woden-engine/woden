as yet unclassified
addChild: aChild
	super addChild: aChild.
	updatedPerFrame ifFalse: [
		self assert: children last == aChild.
		childOffsetDictionary at: aChild put: (children size - 1) * WTGenericObjectState structureSize.
		pendingUpdates add: aChild.
	]