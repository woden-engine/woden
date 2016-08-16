as yet unclassified
instanceWasRemoved: aNode
	updatedPerFrame ifFalse: [
		pendingUpdates remove: aNode ifAbsent: [].
		childOffsetDictionary remove: aNode ifAbsent: [] 
	]