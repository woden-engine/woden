utility
getNormalizedForLineWidthValues: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation
	"aBlock is evaluated on each node model"

	self checkNotEmpty.
	(maxValue = minValue) ifTrue: [ 
		^ self edges collect: [ :edge | min ] ].
	
 	^ self edges collect: [ :edge | 
			| tt t |
			t := transformation rtValue: (metricBlock value: edge from model value: edge to model).
			tt := min + ((max - min) * ( (t - minValue) / (maxValue - minValue))) asInteger ]