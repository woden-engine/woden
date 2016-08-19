volume insertion
insertPoints: points
	<argument: #points type: #(WMVector3D array object)>
	| point |
	1 to: points size do: [ :pointIndex |
		point := points at: pointIndex.
		min x: (min x min: point x) asNativeFloat.
		min y: (min y min: point y) asNativeFloat.
		min z: (min z min: point z) asNativeFloat.
		max x: (max x max: point x) asNativeFloat.
		max y: (max y max: point y) asNativeFloat.
		max z: (max z max: point z) asNativeFloat.
	]