public normalize line width
normalizeLineWidth: metricBlock min: min max: max
	"metricBlock is a two arg block that accept the from model and the to model"
	^ self normalizeLineWidth: metricBlock min: min max: max using: #yourself