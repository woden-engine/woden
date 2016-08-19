special quaternions
yrot: angle
	<var: #(c s z) type: #float> 
	| c s z |
	c := (angle * 0.5) cos asNativeFloat.
	s := (angle * 0.5) sin asNativeFloat.
	z := 0.0 asNativeFloat.
	^ self r: c i: z j: s k: z