transformations
scaleX: fx Y: fy
	matrix := matrix * (WMMatrix3F scaleX: fx asFloat y: fy asFloat z: 1.0)