as yet unclassified
removeChild: aChild
	super removeChild: aChild.
	updatedPerFrame ifFalse: [
		childOffsetDictionary remove: aChild.
		pendingUpdates remove: aChild ifAbsent: [].
	].
