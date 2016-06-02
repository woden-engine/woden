initialization
initialize
	super initialize.
	flattnessFactor := self class defaultFlattnessFactor.
	pixelThreshold := self class defaultPixelThreshold.
	transformation := WMMatrix3F identity.