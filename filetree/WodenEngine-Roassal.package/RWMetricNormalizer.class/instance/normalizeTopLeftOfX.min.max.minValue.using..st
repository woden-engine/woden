public normalize x
normalizeTopLeftOfX: metricBlock min: min max: max minValue: minValue using: transformation
	"metricBlock is evaluated on each node model. 	
	 min represent the X value of the minimum value.
	 max represent the X value of the maximum value.
	 transformation is used to transform the metric value"
	
	| maxValue |
	"We get the min and the max of the metric for all the elements"
	maxValue := transformation rtValue: (metricBlock rtValue: elements anyOne model).
	elements do: [ :el | 
		| t |  
		t := transformation rtValue: (metricBlock rtValue: el model).
		maxValue := maxValue max: t ].
	
	self normalizeTopLeftOfX: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation