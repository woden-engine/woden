as yet unclassified
removeChild: aChild
	updatedPerFrame ifTrue: [ aChild visible: false ].
	super removeChild: aChild.
	updatedPerFrame ifFalse: [
		childOffsetDictionary removeKey: aChild.
		pendingUpdates remove: aChild ifAbsent: [].
	].
