transformations
translateX: px Y: py
	matrix := matrix * (WMMatrix3F translate2DX: px asFloat y: py asFloat)