initialization
initialize
	super initialize.
	transform := WMReversibleAffineTransformD identity.
	localBoundingBox := WMBox3DD min: DefaultHalfExtent negated max: DefaultHalfExtent.
	boundingBox := localBoundingBox copy.
	hasVolume := false.