initialization
initialize
	super initialize.
	flattnessFactor := self class defaultFlattnessFactor.
	pixelThreshold := self class defaultPixelThreshold.
	arcSegmentLength := self class defaultArcSegmentLength.
	maxArcSegments := self class defaultMaxArcSegments.
	transformation := WMMatrix3F identity.