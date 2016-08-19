special quaternions
yrot: angle
	<var: #(c s z) type: #double> 
	| c s z |
	c := (angle * 0.5) cos asNativeDouble.
	s := (angle * 0.5) sin asNativeDouble.
	z := 0.0 asNativeDouble.
	^ self r: c i: z j: s k: z