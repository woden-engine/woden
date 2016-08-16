public normalize size
normalizeHeight: metricBlock
	"metricBlock is evaluated on each node model"
	^ self normalizeHeight: metricBlock min: 5 max: 30