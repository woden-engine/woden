volume insertion
insertPoint: aPoint
	<argument: #aPoint type: #(WMVector3D object)>
	min x: (min x min: aPoint x) asNativeFloat.
	min y: (min y min: aPoint y) asNativeFloat.
	min z: (min z min: aPoint z) asNativeFloat.
	max x: (max x max: aPoint x) asNativeFloat.
	max y: (max y max: aPoint y) asNativeFloat.
	max z: (max z max: aPoint z) asNativeFloat.