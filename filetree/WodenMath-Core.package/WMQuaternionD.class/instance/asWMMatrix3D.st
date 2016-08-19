converting
asWMMatrix3D
	<var: #(one two) type: #double>
	| one two |
	one := 1.0 asNativeDouble.
	two := 2.0 asNativeDouble.
	^ WMMatrix3D
		m11: one - (two*j*j) - (two*k*k)
		m12: (two*i*j) - (two*k*r)
		m13: (two*i*k) + (two*j*r)
		
		m21: (two*i*j) + (two*k*r)
		m22: one - (two*i*i) - (two*k*k)
		m23: (two*j*k) - (two*i*r)
		
		m31: (two*i*k) - (two*j*r)
		m32: (two*j*k) + (two*i*r)
		m33: one - (two*i*i) - (two*j*j)
		