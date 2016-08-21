special quaternions
axis: axis angle: angle
	<argument: #axis type: #(WMVector3D object)> 
	<argument: #angle type: #double>
	<var: #(c s) type: #double> 
	| c s |
	c := (angle * 0.5) cos asNativeDouble.
	s := (angle * 0.5) sin asNativeDouble.
	^ self r: c i: axis x * s j: axis y * s k: axis z * s