public normalize size
normalizeElementHeight: metricBlock
	"metricBlock is evaluated on each node model"
	^ self normalizeElementHeight: metricBlock min: 5 max: 30