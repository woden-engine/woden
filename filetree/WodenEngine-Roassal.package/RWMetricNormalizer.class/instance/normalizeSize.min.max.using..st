public normalize size
normalizeSize: metricBlock min: min max: max using: transformation
	"aBlock is evaluated on each node model. 
	 Colors is an array of colors used to do the fading"
	
	| minValue maxValue |
	
	self checkNotEmpty.
	elements size <= 1 ifTrue: [ ^ self ].

	"We get the min and the max of the metric for all the elements"
	minValue := transformation rtValue: (metricBlock rtValue: elements anyOne model).
	maxValue := minValue.
	elements do: [ :el | 
		| t |  
		t := transformation rtValue: (metricBlock rtValue: el model).
		minValue := minValue min: t.
		maxValue := maxValue max: t ].
	
	self normalizeSize: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation