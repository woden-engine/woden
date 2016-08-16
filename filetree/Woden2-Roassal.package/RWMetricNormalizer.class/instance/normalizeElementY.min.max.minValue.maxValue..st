public normalize x
normalizeElementY: metricBlock min: min max: max minValue: minValue maxValue: maxValue 
	"
	metricBlock is evaluated on each element. 	

	min represent the Y value of the minimum value.
	max represent the Y value of the maximum value.
	
	minValue is the minimum value of the dataset.
	maxValue is the maximum value of the dataset.
	
	[ minValue ; maxValue ] is mapped to [ min ; max ]

	transformation is used to transform the metric value"
		
	self normalizeElementY: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: #yourself