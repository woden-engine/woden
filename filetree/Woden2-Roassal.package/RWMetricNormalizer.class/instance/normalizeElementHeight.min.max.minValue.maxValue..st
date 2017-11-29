public normalize size
normalizeElementHeight: metricBlock min: min max: max minValue: aMinValue maxValue: aMaxValue
	"metricBlock is evaluated on each node model. 
	 minValue and maxValue are integer representing the minimum and maximum size in pixels for each node"
	self normalizeElementHeight: metricBlock min: min max: max minValue: aMinValue maxValue: aMaxValue using: #yourself