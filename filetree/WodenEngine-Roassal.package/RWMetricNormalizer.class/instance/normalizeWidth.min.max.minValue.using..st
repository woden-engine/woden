public normalize size
normalizeWidth: metricBlock min: min max: max minValue: minValue using: transformation
	"aBlock is evaluated on each node model"
	
	|  maxValue |
	
	self checkNotEmpty.

	"We get the max of the metric for all the elements"
	maxValue := transformation rtValue: (metricBlock rtValue: elements anyOne model).
	
	elements do: [ :el | 
		| t |  
		t := transformation rtValue: (metricBlock rtValue: el model).
		maxValue := maxValue max: t ].

	self normalizeWidth: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation
