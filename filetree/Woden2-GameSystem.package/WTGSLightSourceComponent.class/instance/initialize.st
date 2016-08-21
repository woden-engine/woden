initialization
initialize
	super initialize.
	intensity := WMVector4F x: 1.0 y: 1.0 z: 1.0 w: 1.0.
	type := #point.
	outerSpotCutoff := 90.0.
	innerSpotCutoff := 80.0.