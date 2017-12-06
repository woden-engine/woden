public normalize color
normalizeColorAsGray: metricBlock
	"aBlock is evaluated on each node model."
	^ self normalizeColor: metricBlock using: (Array with: Color white with: Color black)