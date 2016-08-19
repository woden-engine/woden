intersection
intersect: second intersect: third
	<argument: #(second third) type: #(SelfType object)>	
	| matrix point |
	matrix := WMMatrix3D
		m11: nx m12: ny m13: nz
		m21: second nx m22: second ny m23: second nz
		m31: third nx m32: third ny m33: third nz.
	point := WMVector3D x: d y: second d z: third d.
	^ matrix solveSystemAtPoint: point.