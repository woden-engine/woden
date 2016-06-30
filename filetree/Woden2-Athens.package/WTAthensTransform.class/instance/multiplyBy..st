transformations
multiplyBy: m
	| wm |
	wm := WMMatrix3F 
		m11: m sx asFloat m12: m shx asFloat m13: m x asFloat
		m21: m shy asFloat m22: m sy asFloat m23: m y asFloat
		m31: 0.0 m32: 0.0 m33: 1.0.
	matrix := matrix * wm