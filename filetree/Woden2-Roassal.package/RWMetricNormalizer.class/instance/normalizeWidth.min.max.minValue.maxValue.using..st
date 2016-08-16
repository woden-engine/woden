public normalize size
normalizeWidth: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation
	"aBlock is evaluated on each node model. 
	 Colors is an array of colors used to do the fading"
		
	| values |
	self checkNotEmpty.	
	
	values := (self getNormalizedValues: metricBlock 
							min: min max: max 
							minValue: minValue maxValue: maxValue 
							using: transformation).
	elements with: values do: [ :el :v | el trachelShape width: v ] 
