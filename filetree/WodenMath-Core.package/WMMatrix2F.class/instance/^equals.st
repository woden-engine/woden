comparing
= other
	^ self class = other class and:
		[ (m11 = other m11) and:
		[ (m12 = other m12) and:
		
		[ (m21 = other m22) and:
		[ (m22 = other m22) ]]]]