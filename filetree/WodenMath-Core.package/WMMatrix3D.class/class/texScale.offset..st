special matrices
texScale: scale offset: offset
	<argument: #(scale offset) type: #(WMVector2D object)> 
	<var: #(zero one) type: #double>
	| zero one | 
	zero := 0.0 asNativeDouble.
	one := 1.0 asNativeDouble.
	"Computes a texture matrix that performs a scale and a translation. Scale and offset are 2D points"
	^ self
		m11: scale x m12: zero m13: offset x
		m21: zero m22: scale y m23: offset y
		m31: zero m32: zero m33: one