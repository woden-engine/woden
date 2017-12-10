initialization
initialize
	super initialize.
	castShadows := false.
	outerSpotCutoff := DefaultSpotOuterCutoff.
	innerSpotCutoff := DefaultSpotInnerCutoff.
	state := WTLightSourceData new.
	state
		intensity: Color white asWMVector4F;
		radius: 3.0.
	self point.