public normalize line width
normalizeLineWidth: metricBlock min: min max: max using: transformation
	"metricBlock is a two arg block that accept the from model and the to model"
	| e minValue maxValue |
	self checkNotEmpty.
	
	"We get the min and the max of the metric for all the edges"
	self edges ifEmpty: [ ^ self ].
	e := self edges anyOne.
	minValue := transformation rtValue: (metricBlock value: e from model value: e to model).
	maxValue := minValue.
	self edges do: [ :edge | 
		| t |  
		t := transformation rtValue: (metricBlock value: edge from model value: edge to model).
		minValue := minValue min: t.
		maxValue := maxValue max: t ].
	
	^ self normalizeLineWidth: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation