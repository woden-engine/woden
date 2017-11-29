as yet unclassified
initialize
	super initialize.
	pendingUpdates := Set new.
	childOffsetDictionary := Dictionary new.
	depthSorted := false.
	lastForwardDirection := WMVector3F new.