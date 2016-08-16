public normalize y
normalizeY: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation
	"
	metricBlock is evaluated on each node model. 	

	min represent the Y value of the minimum value.
	max represent the Y value of the maximum value.
	
	minValue is the minimum value of the dataset.
	maxValue is the maximum value of the dataset.
	
	[ minValue ; maxValue ] is mapped to [ min ; max ]

	transformation is used to transform the metric value"
		
	(maxValue - minValue) ~= 0 ifTrue: [
		elements do: [ :el | 
			| tt t |
			t := transformation rtValue: (metricBlock rtValue: el model).
			tt := self getValue: t min: min max: max minValue: minValue maxValue: maxValue.
			translator translate: el to: el position + (WDVector3 x: 0.0 y: tt asFloat z: 0.0) ] ] 