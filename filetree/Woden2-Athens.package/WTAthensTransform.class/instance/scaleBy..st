transformations
scaleBy: factor
	matrix := matrix * (WMMatrix3F scaleX: factor asFloat y: factor asFloat z: 1.0)