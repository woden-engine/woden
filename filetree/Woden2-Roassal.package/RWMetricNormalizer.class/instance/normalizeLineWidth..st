public normalize line width
normalizeLineWidth: metricBlock
	"metricBlock is a two arg block that accept the from model and the to model"
	^ self normalizeLineWidth: metricBlock min: 0.5 max: 30