public normalize size
normalizeWidth: metricBlock max: maxValue
	"metricBlock is evaluated on each node model. 
	 maxValue is an integer representing the maximum size in pixels for each node"
	self normalizeWidth: metricBlock min: 5 max: maxValue