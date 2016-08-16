public normalize x
normalizeX: metricBlock min: min max: max minValue: minValue
	"metricBlock is evaluated on each node model. 	
	 min represent the X value of the minimum value.
	 max represent the X value of the maximum value.
	 transformation is used to transform the metric value"
	
	^ self normalizeX: metricBlock min: min max: max minValue: minValue using: #yourself