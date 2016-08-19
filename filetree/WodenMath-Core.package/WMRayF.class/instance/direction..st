accessing
direction: value
	<argument: #value type: #(WMVector3F object)>
	direction := value.
	
	invertedDirection := direction reciprocalFloatQuiet.	
	signs x: (invertedDirection x < 0) asBit asNativeShort.
	signs y: (invertedDirection y < 0) asBit asNativeShort.
	signs z: (invertedDirection z < 0) asBit asNativeShort.