public normalize line width
normalizeLineWidth: metricBlock min: min max: max minValue: minValue maxValue: maxValue using: transformation
	| values |
	self checkNotEmpty.
	
	values := (self getNormalizedForLineWidthValues: metricBlock 
							min: min 
							max: max 
							minValue: minValue 
							maxValue: maxValue 
							using: transformation).
	self edges with: values do: [ :edge :v | edge shape width: v ] 
	
	