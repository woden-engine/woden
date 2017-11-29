public normalize size
normalizeWidth: metricBlock
	"metricBlock is evaluated on each node model."
	^ self normalizeWidth: metricBlock min: 5 max: 30