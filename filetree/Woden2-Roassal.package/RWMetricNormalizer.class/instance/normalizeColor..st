public normalize color
normalizeColor: metricBlock
	"aBlock is evaluated on each node model. 
	 Colors is an array of colors used to do the fading"
	^ self normalizeColor: metricBlock using: (Array with: Color gray with: Color red)