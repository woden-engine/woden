volume insertion
insertBox: aBox
	<argument: #aBox type: #(SelfType object)>
	min x: (min x min: aBox min x) asNativeFloat.
	min y: (min y min: aBox min y) asNativeFloat.
	min z: (min z min: aBox min z) asNativeFloat.
	max x: (max x max: aBox max x) asNativeFloat.
	max y: (max y max: aBox max y) asNativeFloat.
	max z: (max z max: aBox max z) asNativeFloat.