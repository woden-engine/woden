public normalize position
normalizePosition: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation
	"aBlock is evaluated on each node model"
	
	| values |
	values := (self getNormalizedValues: metricBlock 
							min: min max: max 
							minValue: minValue maxValue: maxValue 
							using: transformation).
	elements with: values do: [ :el :v | translator translate: el to: el position + (v asIntegerPoint) ] 
