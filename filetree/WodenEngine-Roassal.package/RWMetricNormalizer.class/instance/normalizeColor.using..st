public normalize color
normalizeColor: metricBlock using: colors
	"aBlock is evaluated on each node model. 
	 Colors is an array of colors used to do the fading"
	^ self normalizeColor: metricBlock using: colors using: #yourself