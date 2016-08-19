arithmetic
transposed
	^ self new
		m11: m11; m12: m21; m13: m31; m14: m41;
		m21: m12; m22: m22; m23: m32; m24: m42;
		m31: m13; m32: m23; m33: m33; m34: m43;
		m41: m14; m42: m24; m43: m34; m44: m44;
		yourself