arithmetic
* other
	<argument: #other type: #(SelfType object)>
	<returnType: #(SelfType object)>
	^ self class
		m11: (m11 * other m11) + (m12 * other m21) + (m13 * other m31)
		m12: (m11 * other m12) + (m12 * other m22) + (m13 * other m32)
		m13: (m11 * other m13) + (m12 * other m23) + (m13 * other m33)
		
		m21: (m21 * other m11) + (m22 * other m21) + (m23 * other m31)
		m22: (m21 * other m12) + (m22 * other m22) + (m23 * other m32)
		m23: (m21 * other m13) + (m22 * other m23) + (m23 * other m33)
		
		m31: (m31 * other m11) + (m32 * other m21) + (m33 * other m31)
		m32: (m31 * other m12) + (m32 * other m22) + (m33 * other m32)
		m33: (m31 * other m13) + (m32 * other m23) + (m33 * other m33)