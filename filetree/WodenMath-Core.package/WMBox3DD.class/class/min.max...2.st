construction
min: min max: max
	<constructor>
	<argument: #(min max) type: #(WMVector3D object)>
	^ self new
		min: min;
		max: max;
		yourself