public normalize size
normalizeHeight: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation
	"metricBlock is evaluated on each node model. 
	 minValue and maxValue are integer representing the minimum and maximum size in pixels for each node"

	| values |

	self checkNotEmpty.
	
	values := (self getNormalizedValues: metricBlock 
							min: min max: max 
							minValue: minValue maxValue: maxValue 
							using: transformation).
	elements with: values do: [ :el :v | el trachelShape height: v ] 
	
	