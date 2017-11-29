public normalize size
normalizeWidth: metricBlock min: min max: max minValue: minValue maxValue: maxValue
	"aBlock is evaluated on each node model"
	
	^ self normalizeWidth: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: #yourself