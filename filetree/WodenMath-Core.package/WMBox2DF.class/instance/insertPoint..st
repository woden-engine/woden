volume insertion
insertPoint: aPoint
	<argument: #aPoint type: #(WMVector2F object)>
	min x: (min x min: aPoint x) asNativeFloat.
	min y: (min y min: aPoint y) asNativeFloat.
	max x: (max x max: aPoint x) asNativeFloat.
	max y: (max y max: aPoint y) asNativeFloat.