public normalize x
normalizeTopLeftOfX: metricBlock
	"metricBlock is evaluated on each node model"
	^ self normalizeTopLeftOfX: metricBlock min: 0 max: 200