volume insertion
insertBox: aBox
	<argument: #aBox type: #(WMBox2DF object)>
	min x: (min x min: aBox min x) asNativeFloat.
	min y: (min y min: aBox min y) asNativeFloat.
	max x: (max x max: aBox max x) asNativeFloat.
	max y: (max y max: aBox max y) asNativeFloat. 