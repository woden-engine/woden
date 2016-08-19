arithmetic
* other
	<argument: #other type: #(SelfType object)>
	<returnType: #(SelfType object)>
	^ self class 
		m11: (m11 * other m11) + (m12 * other m21)
		m12: (m11 * other m12) + (m12 * other m22)
		
		m21: (m21 * other m11) + (m22 * other m21)
		m22: (m21 * other m12) + (m22 * other m22)