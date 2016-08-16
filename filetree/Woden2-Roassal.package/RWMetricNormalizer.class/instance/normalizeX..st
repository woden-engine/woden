public normalize x
normalizeX: metricBlock
	"metricBlock is evaluated on each node model"
	^ self normalizeX: metricBlock min: 0 max: 200