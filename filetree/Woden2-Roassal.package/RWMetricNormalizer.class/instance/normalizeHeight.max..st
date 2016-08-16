public normalize size
normalizeHeight: metricBlock max: maxValue
	"metricBlock is evaluated on each node model. 
	 maxValue is an integer representing the maximum size in pixels for each node"
	self normalizeHeight: metricBlock min: 5 max: maxValue