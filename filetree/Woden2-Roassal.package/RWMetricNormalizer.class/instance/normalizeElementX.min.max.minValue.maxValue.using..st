public normalize x
normalizeElementX: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation
	"
	metricBlock is evaluated on each element. 	

	min represent the X value of the minimum value.
	max represent the X value of the maximum value.
	
	minValue is the minimum value of the dataset.
	maxValue is the maximum value of the dataset.
	
	[ minValue ; maxValue ] is mapped to [ min ; max ]

	transformation is used to transform the metric value"
		
	(maxValue - minValue) ~= 0 ifTrue: [
		elements do: [ :el | 
			| tt t |
			t := transformation rtValue: (metricBlock rtValue: el).
			tt := min + ((max - min) * ( (t - minValue) / (maxValue - minValue))) asInteger.
			translator translate: el to: el position + (WDVector3 x: tt asFloat y: 0.0 z: 0.0) ] ] 