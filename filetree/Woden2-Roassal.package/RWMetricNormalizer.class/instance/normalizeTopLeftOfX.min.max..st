public normalize x
normalizeTopLeftOfX: metricBlock min: minValue max: maxValue
	"metricBlock is evaluated on each node model. 
	 minValue and maxValue are integer representing the minimum and maximum size in pixels for each node"
	self normalizeTopLeftOfX: metricBlock min: minValue max: maxValue using: #yourself