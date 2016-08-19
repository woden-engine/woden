arithmetic
* other
	<argument: #other type: #(SelfType object)>
	^ self class new
		m11: (m11 * other m11) + (m12 * other m21) + (m13 * other m31) + (m14 * other m41);
		m12: (m11 * other m12) + (m12 * other m22) + (m13 * other m32) + (m14 * other m42);
		m13: (m11 * other m13) + (m12 * other m23) + (m13 * other m33) + (m14 * other m43);
		m14: (m11 * other m14) + (m12 * other m24) + (m13 * other m34) + (m14 * other m44);
		
		m21: (m21 * other m11) + (m22 * other m21) + (m23 * other m31) + (m24 * other m41);
		m22: (m21 * other m12) + (m22 * other m22) + (m23 * other m32) + (m24 * other m42);
		m23: (m21 * other m13) + (m22 * other m23) + (m23 * other m33) + (m24 * other m43);
		m24: (m21 * other m14) + (m22 * other m24) + (m23 * other m34) + (m24 * other m44);
		
		m31: (m31 * other m11) + (m32 * other m21) + (m33 * other m31) + (m34 * other m41);
		m32: (m31 * other m12) + (m32 * other m22) + (m33 * other m32) + (m34 * other m42);
		m33: (m31 * other m13) + (m32 * other m23) + (m33 * other m33) + (m34 * other m43);
		m34: (m31 * other m14) + (m32 * other m24) + (m33 * other m34) + (m34 * other m44);
		
		m41: (m41 * other m11) + (m42 * other m21) + (m43 * other m31) + (m44 * other m41);
		m42: (m41 * other m12) + (m42 * other m22) + (m43 * other m32) + (m44 * other m42);
		m43: (m41 * other m13) + (m42 * other m23) + (m43 * other m33) + (m44 * other m43);
		m44: (m41 * other m14) + (m42 * other m24) + (m43 * other m34) + (m44 * other m44);
		yourself