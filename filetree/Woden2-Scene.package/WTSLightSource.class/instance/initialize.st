initialization
initialize
	super initialize.
	state := WTLightSourceData new.
	state
		intensity: Color white asWMVector4F;
		radius: 3.0.
	self point.