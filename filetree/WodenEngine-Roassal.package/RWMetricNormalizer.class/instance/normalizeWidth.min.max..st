public normalize size
normalizeWidth: metricBlock min: minValue max: maxValue
	"metricBlock is evaluated on each node model. 
	 minValue and maxValue are integer representing the minimum and maximum size in pixels for each node"
	self normalizeWidth: metricBlock min: minValue max: maxValue using: #yourself