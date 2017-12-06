public normalize position
normalizePosition: metricBlock min: min max: max using: transformation
	"aBlock is evaluated on each node model"
	
	| minValue maxValue |
	"We get the min and the max of the metric for all the elements"
	minValue := transformation rtValue: (metricBlock rtValue: elements anyOne model).
	maxValue := minValue.
	elements do: [ :el | 
		| t |  
		t := transformation rtValue: (metricBlock rtValue: el model).
		minValue := minValue min: t.
		maxValue := maxValue max: t ].
	
	(maxValue - minValue) ~= (0 @ 0) ifTrue: [ 
		elements do: [ :el | 
			| tt t |
			t := transformation rtValue: (metricBlock rtValue: el model).
			"tt := minValue + (maxValue * (t - min) / max) asInteger."
			tt := min + ((max - min) * ( (t - minValue) / (maxValue - minValue))) asIntegerPoint.
			translator translate: el to: (tt) ] ] 
