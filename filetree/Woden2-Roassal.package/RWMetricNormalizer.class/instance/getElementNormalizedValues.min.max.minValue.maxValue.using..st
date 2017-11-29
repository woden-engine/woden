utility
getElementNormalizedValues: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation
	"aBlock is evaluated on each node model"

	self checkNotEmpty.
	(maxValue = minValue) ifTrue: [ 
		^ elements collect: [ :el | min ] ].
	
 	^ elements collect: [ :el | 
			| tt t |
			t := transformation rtValue: (metricBlock rtValue: el).
			tt := min + ((max - min) * ( (t - minValue) / (maxValue - minValue))) asInteger ]