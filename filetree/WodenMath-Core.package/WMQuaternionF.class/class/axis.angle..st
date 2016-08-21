special quaternions
axis: axis angle: angle
	<argument: #axis type: #(WMVector3F object)> 
	<argument: #angle type: #float>
	<var: #(c s) type: #float> 
	| c s |
	c := (angle * 0.5) cos asNativeFloat.
	s := (angle * 0.5) sin asNativeFloat.
	^ self r: c i: axis x * s j: axis y * s k: axis z * s