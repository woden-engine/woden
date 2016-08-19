construction
min: min max: max
	<constructor>
	<argument: #(min max) type: #(WMVector3F object)>
	^ self new
		min: min;
		max: max;
		yourself