public normalize x
normalizeTopLeftOfX: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation
	"
	metricBlock is evaluated on each node model. 	

	min represent the X value of the minimum value.
	max represent the X value of the maximum value.
	
	minValue is the minimum value of the dataset.
	maxValue is the maximum value of the dataset.
	
	[ minValue ; maxValue ] is mapped to [ min ; max ]

	transformation is used to transform the metric value"
		
	(maxValue - minValue) ~= 0 ifTrue: [
		elements do: [ :el | 
			| tt t |
			t := transformation rtValue: (metricBlock rtValue: el model).
			tt := self getValue: t min: min max: max minValue: minValue maxValue: maxValue.
			translator translateTopLeftOf: el to: el encompassingRectangle topLeft + (tt @ 0) ] ] 